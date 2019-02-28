//  Created by Reem Saloom on 1/26/19.
//  Copyright © 2019 Reem AlSalloom. All rights reserved.
//


import UIKit
import CoreData
import MapKit



class MapVC: UIViewController
{
    
    
    
    @IBOutlet weak var mapView: MKMapView!
    // lazy var store = delegate.store
    var pins = [Pin]()
    var store:StoreController!
    var selectedPin : Pin!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let longGesture = UILongPressGestureRecognizer(target: self, action:#selector(longPress(_:)))
        mapView.addGestureRecognizer(longGesture)
        loadPins()
    }
    
    func loadPins() {
        pins = PinItem.getPins(context: store.context)
        for pin in pins {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
            mapView.addAnnotation(annotation)
        }
    }
    
    @objc func longPress(_ sender: UIGestureRecognizer){
        if sender.state == .ended {
            let coordinate = mapView.convert(sender.location(in: mapView),toCoordinateFrom: mapView)
            selectedPin = PinItem.add(latitude: coordinate.latitude, longitude: coordinate.longitude, context: store.context)
            loadPins()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show", let vc = segue.destination as? PhotosAlbumVC {
            vc.pin = selectedPin
            vc.store = store
        }
    }
    
    
    
}

extension MapVC: MKMapViewDelegate
{
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let pin = PinItem.getPinByCoordination(pins: pins, coordinate: view.annotation?.coordinate)
        if let pin = pin {
            selectedPin = pin
            self.performSegue(withIdentifier: "show", sender: self)
        }
        mapView.deselectAnnotation(view.annotation, animated: true)
        
    }
    
    
}
