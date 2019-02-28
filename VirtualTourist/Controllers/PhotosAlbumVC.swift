//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by Reem Saloom on 1/26/19.
//  Copyright © 2019 Reem AlSalloom. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotosAlbumVC:  UIViewController
{
    
    
    @IBOutlet weak var detailMapView: MKMapView!
    @IBOutlet weak var newCollectionBtn: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var pin: Pin!
    var page = 0
    var store : StoreController!
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultsController = PhotoItem.fetchController(pin: pin, context: store.context)
        
        detailMapView.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        fetchedResultsController.delegate = self
        
        showLocation()
        getImages()
    }
    
    
    func getImages(){
        do{
            try fetchedResultsController.performFetch()
            if fetchedResultsController.fetchedObjects?.count  == 0{
                page = page + 1
                PhotoItem.getImagesUrls(lat: pin.latitude, long: pin.longitude,page:page) { (urls,error) in
                    if let error = error {
                        self.collectionView.showMessage(error)
                        return
                    }
                    for url in urls{
                        PhotoItem.add(url: url,pin:self.pin,context: self.store.context)
                    }
                    self.collectionView.reloadData()
                }
            }
            else{
                collectionView.reloadData()
            }
        }
        catch{
            fatalError("Error fetching: \(error.localizedDescription)")
        }
        
    }
    //button
    
    @IBAction func newCollection(_ sender: Any) {
    
        print("new Collection")
        PhotoItem.deleteAll(fetchController: fetchedResultsController, context: store.context)
        collectionView.reloadData()
        getImages()
    }
    func showLocation(){
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
        detailMapView.addAnnotation(annotation)
        detailMapView.region.center = annotation.coordinate
        let viewRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        detailMapView.setRegion(viewRegion, animated: false)
        detailMapView.selectAnnotation(detailMapView.annotations[0], animated: true)
        
    }
    
    
    
    
    
}

extension PhotosAlbumVC : NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert,.update,.delete:
            self.collectionView.reloadData()
        default:
            return
        }
    }
}
extension PhotosAlbumVC : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? MKPinAnnotationView
        if let annotationView = annotationView {
            annotationView.annotation = annotation
        }
        else {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            annotationView!.canShowCallout = true
            let btn = UIButton(type: .detailDisclosure)
            annotationView!.rightCalloutAccessoryView = btn
        }
        
        return annotationView
    }
}

extension PhotosAlbumVC :    UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //TODO: Return the number of items
        if (fetchedResultsController.fetchedObjects?.count  == 0) {
            collectionView.showMessage("No images available in this location! ")
        } else {
            collectionView.restore()
        }
        
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! PhotoCellVC
        cell.photo = fetchedResultsController.object(at: indexPath)
        if let image = cell.photo.image {
            cell.imageView.image = UIImage(data:image)
        } else if let url = URL(string: cell.photo.url!) {
            cell.imageView.kf.indicatorType = .activity
            cell.imageView.kf.setImage(with: url)
        }
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width - 10
        
        return CGSize(width: width/4, height: width/4)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 2
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        PhotoItem.delete(photo: fetchedResultsController.object(at: indexPath), context: store.context)
    }
    
}

extension UICollectionView {
    
    func showMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textAlignment = .center;
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
    }
    
    func restore() {
        self.backgroundView = nil
    }
}

