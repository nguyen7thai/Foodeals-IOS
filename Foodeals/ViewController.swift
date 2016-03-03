//
//  ViewController.swift
//  Foodeals
//
//  Created by Thai Nguyen on 2/23/16.
//  Copyright © 2016 Thai Nguyen. All rights reserved.
//


import UIKit
import MapKit


class ViewController: UIViewController, MKMapViewDelegate {
    
    let geocoder = CLGeocoder()
    let locationmgr = CLLocationManager()
    
    @IBOutlet weak var displayMap: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationmgr.requestWhenInUseAuthorization()
        
        self.displayMap.showsUserLocation = true
        self.displayMap.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        let client = DealClient()
        client.getDeals { (data, error) in
            if error == nil {
                var annotations = [MapPin]()
                
                for deal in data! {
                    let annotation = MapPin()
                    annotation.title = deal.title
                    annotation.subtitle = deal.address
                    
                    let coordinate = CLLocationCoordinate2D(latitude: deal.lat, longitude: deal.long)
                    annotation.coordinate = coordinate
                    annotation.dealUrl = deal.url
                    annotations.append(annotation)
                }
                
                performUIUpdatesOnMain {
                    self.displayMap.addAnnotations(annotations)
                }
            } else {
                print(error)
            }
        }
    }
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        displayMap.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? MapPin {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView { // 2
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                let button = MyButton(type: .DetailDisclosure)
                button.url = annotation.dealUrl
//                button.setValue(annotation.dealUrl, forKey: "deal_url")
                view.rightCalloutAccessoryView = button as UIView
            }
            return view
        } else {
            return nil
        }
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("click")
//        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
        let button = control as! MyButton
//        controller.url = button.url
        let url = NSURL(string: button.url!)
        UIApplication.sharedApplication().openURL(url!)
//        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func goToMyLocation(sender: UIBarButtonItem) {
        if let location = locationmgr.location {
            centerMapOnLocation(location)
        }
    }


}

class MyButton: UIButton {
    var url: String?
}

