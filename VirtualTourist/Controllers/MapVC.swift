//  Created by Reem Saloom on 1/26/19.
//  Copyright © 2019 Reem AlSalloom. All rights reserved.
//


import UIKit
import CoreData
import MapKit


let delegate = UIApplication.shared.delegate as! AppDelegate

class MapVC: UIViewController,  UIGestureRecognizerDelegate, MKMapViewDelegate
{
   

    
    @IBOutlet weak var mapView: MKMapView!
    lazy var store = delegate.store
    
   var fetchedResultController: NSFetchedResultsController<Pin>?
    
    let fetchRequest = NSFetchRequest<Pin>(entityName: "Pin")
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        
        mapView.delegate = self
        let gest = UILongPressGestureRecognizer(target: self, action: #selector(addpin(_: )))
        gest.delegate = self
        gest.minimumPressDuration = 0.5
        gest.allowableMovement = 1
        mapView.addGestureRecognizer(gest)

        
        
        self.loadData()
        
    }
    
    @objc func addpin(_ gest: UILongPressGestureRecognizer)
    {
        if gest.state == UIGestureRecognizer.State.began
        {
            let loc = gest.location(in: mapView)
            let coord = mapView.convert(loc, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coord
            let pin = PinItem(lat: coord.latitude,long: coord.longitude, context: (fetchedResultController?.managedObjectContext)!)
            try! store.saveContext()
            loadData()
        }
    }
    
    public func mapView(_ mapview: MKMapView, didSelect view: MKAnnotationView)
    {
        var point: NSManagedObject!
        
        let latPredicate = NSPredicate(format: "latitude = %@", argumentArray: [(view.annotation?.coordinate.latitude)!])
        let longPredicate = NSPredicate(format: "longitude = %@", argumentArray: [(view.annotation?.coordinate.longitude)!])
        
        let fetchRequest = NSFetchRequest<Pin>(entityName: "Pin")
        
        let combinedPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [latPredicate, longPredicate])
        
        fetchRequest.predicate = combinedPredicate
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "latitude", ascending: true)]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: store.context, sectionNameKeyPath: nil, cacheName: nil)
        
      //  fetchCompletion(fetchResultController: fetchedResultController, completion: {
            
                let objc = fetchedResultController?.fetchedObjects as! [NSManagedObject]
            
                point = objc[0]
      //  })
        mapview.deselectAnnotation(view.annotation, animated: false)
        
        performSegue(withIdentifier: "photoAlbumVC", sender: point)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let target = segue.destination as! PhotosAlbumVC
        target.point = sender as? PinItem
    }
    
}

extension MapVC
{

    
    func loadData()
    {
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "latitude", ascending: false), NSSortDescriptor(key: "longitude", ascending: false)]
      
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: store.context  , sectionNameKeyPath: nil, cacheName: nil)
        
      //  fetchCompletion(fetchResultController: fetchedResultController , completion: {
        
        let pins:[Pin] = (fetchedResultController?.fetchedObjects)!
            
            DispatchQueue.global(qos: .userInitiated).async
                {
                    var annotationList = [MKPointAnnotation]()
                    
                    for pin in pins
                    {
                        let annotation = MKPointAnnotation()
                        
                        annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
                        
                        annotationList.append(annotation)
                    }
                    
                    DispatchQueue.main.async
                        {
                            self.mapView.addAnnotations(annotationList)
                    }
            }
       // })
        
    }
    
    func fetchCompletion(fetchResultController: NSFetchedResultsController<NSFetchRequestResult>?, completion: ()->())
    {
        fetchResultController?.delegate = self as? NSFetchedResultsControllerDelegate
       
        if let fetchResult = fetchedResultController
        {
            do
            {
                try fetchResult.performFetch()
            }
            catch let error as NSError
            {
                print("Search Error : \n\(error)\n\(String(describing: fetchedResultController))")
            }
        }
        
        completion()
    }
    

    
}
