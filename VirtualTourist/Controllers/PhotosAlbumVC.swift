//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by Jaskirat Singh on 07/03/18.
//  Copyright © 2018 jassie. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotosAlbumVC: Core, MKMapViewDelegate, UICollectionViewDataSource
{
    
    
    @IBOutlet weak var detailMapView: MKMapView!
    
    @IBOutlet weak var newCollectionBtn: UIBarButtonItem!
    
    var annotationList = [MKPointAnnotation]()
    var point: PinItem!
    
    @IBAction func collection(_ sender: Any)
    {
        let pic = (self.point.image!) as NSSet

        newCollectionBtn.isEnabled = false

        for object in pic
        {
            self.fetchedResultController?.managedObjectContext.delete(object as! NSManagedObject)
        }

        constructImagesUrls(){ (obtained, error) in
            DispatchQueue.main.async
                {
                    self.newCollectionBtn.isEnabled = true
            }
            if obtained == false
            {
                DispatchQueue.main.async
                    {
                        self.alertError(error: error!)
                }
            }
            try! self.delegate.store.saveContext()
        }
    }
    
    func setup()
    {
        detailMapView.isUserInteractionEnabled = true
        self.newCollectionBtn.isEnabled = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let coordinate2D  = CLLocationCoordinate2D(latitude: (self.point?.latitude)!, longitude: (self.point?.longitude)!)
        let annot = MKPointAnnotation()
        annot.coordinate = coordinate2D
        detailMapView.addAnnotations([annot])
        detailMapView.isScrollEnabled = false
        let span = MKCoordinateSpan(latitudeDelta: 2.5, longitudeDelta: 2.5)
        let region = MKCoordinateRegion(center: coordinate2D, span: span)
        detailMapView.setRegion(region, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        let fetchRequest = NSFetchRequest<Photos>(entityName: "Images")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "pin", ascending: true)]
        let predic = NSPredicate(format: "pin = %@", argumentArray: [self.point])
        fetchRequest.predicate = predic
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: (delegate.store.context), sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultController?.delegate = self
        self.startSearch()
        if(point.image?.count)! < 1
        {
            self.constructImagesUrls(){ (obtained, error) in
                DispatchQueue.main.async
                    {
                        self.newCollectionBtn.isEnabled = true
                }
                if (obtained == false)
                {
                    DispatchQueue.main.async
                        {
                            self.alertError(error: error!)
                    }
                }
                try! self.delegate.store.saveContext()
            }
        }
        else
        {
            self.newCollectionBtn.isEnabled = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pic", for: indexPath) as! PhotoCellVC
        cell.activityIndicator.isHidden = false
        
        cell.activityIndicator.startAnimating()
        
        cell.imageView.image = nil
        
        let object = fetchedResultController!.object(at: indexPath) as! Photos
        
        if object.image == nil
        {
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async
                {
                    let url = URL(string:(object.url)!)
                    let imageData = try? Data(contentsOf: url!)
                    self.fetchedResultController?.managedObjectContext.perform
                        {
                            object.image = imageData! as NSData
                            try! self.delegate.store.saveContext()
                            cell.imageView.image = UIImage(data: (object.image)! as Data)
                            cell.activityIndicator.stopAnimating()
                            cell.activityIndicator.isHidden = true
                    }
            }
        }
        else
        {
            cell.imageView.image = UIImage(data: (object.image)! as Data)
            cell.activityIndicator.stopAnimating()
            cell.activityIndicator.isHidden = true
        }
        return cell
    }
    
    func constructImagesUrls(_ completion: @escaping(_ obtained: Bool, _ error: String?)-> Void)
    {
        let flickr = FlickrData()
        flickr.obtainData(longitude: self.point.longitude, latitude: self.point.latitude, page: Int32(arc4random_uniform(50)), completion: {
            error, urlArray in
            if error != nil
            {
                completion(false, error)
                return
            }
            if urlArray?.count == 0
            {
                completion(false, "ERROR: No data found!")
                return
            }
            for index in urlArray!
            {
                let image = Photos(image: nil, point: self.point, context: (self.fetchedResultController?.managedObjectContext)!)
                image.url = index
            }
            completion(true, nil)
        })
    }
    
    func alertError(error: String)
    {
        DispatchQueue.main.async
            {
                let alert = UIAlertController(title: nil, message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {
                    alert in
                    self.newCollectionBtn.isEnabled = true
                }))
                self.present(alert, animated: true, completion: nil)
        }
    }
    
}

