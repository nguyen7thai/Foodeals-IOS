//
//  ViewController.swift
//  Foodeals
//
//  Created by Thai Nguyen on 2/23/16.
//  Copyright © 2016 Thai Nguyen. All rights reserved.
//


import UIKit
import MapKit


class ViewController: UIViewController, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    let geocoder = CLGeocoder()
    let locationmgr = CLLocationManager()
    
    var dealList:[DealItem] = []
    
    @IBOutlet weak var dealTable: UITableView!
    @IBOutlet weak var displayMap: MKMapView!
    @IBOutlet weak var showListButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationmgr.requestWhenInUseAuthorization()
        
        self.displayMap.showsUserLocation = true
        self.displayMap.delegate = self
        self.dealTable.dataSource = self
        self.dealTable.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        let client = DealClient()
        client.getDeals { (data, error) in
            if error == nil {
                var annotations = [MapPin]()
                self.dealList = data!
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
                    self.dealTable.reloadData()
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
                as? MKPinAnnotationView {
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                let button = MyButton(type: .DetailDisclosure)
                button.url = annotation.dealUrl
                view.rightCalloutAccessoryView = button as UIView

            }
            return view
        } else {
            return nil
        }
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let button = control as! MyButton
        let url = NSURL(string: button.url!)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let row = tableView.dequeueReusableCellWithIdentifier("dealRow")! as! DealTableRow
        row.setItem(dealList[indexPath.item])
        
        return row
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dealList.count
    }
    

    @IBAction func myCurrentLocation(sender: UIButton) {
        if let location = locationmgr.location {
            centerMapOnLocation(location)
            self.dealList = self.sortDealListByDistance(self.dealList)
            performUIUpdatesOnMain {
                self.dealTable.reloadData()
            }
        }
    }
    
    @IBAction func showList(sender: UIButton) {
        let currentState = self.dealTable.hidden
        self.dealTable.hidden = !currentState
        if currentState {
            showListButton.setTitle("Hide List", forState: UIControlState.Normal)
        } else {
            showListButton.setTitle("Show List", forState: UIControlState.Normal)
        }
    }

    func sortDealListByDistance(list: [DealItem]) -> [DealItem] {
        let userLocation = locationmgr.location!
        return list.sort { (a, b) -> Bool in
            let aLocation = CLLocation(latitude: a.lat, longitude: a.long)
            let bLocation = CLLocation(latitude: b.lat, longitude: b.long)
            return (userLocation.distanceFromLocation(aLocation) < userLocation.distanceFromLocation(bLocation))
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let deal = dealList[indexPath.item]
        let location = CLLocation(latitude: deal.lat, longitude: deal.long)
        centerMapOnLocation(location)
    }
    
}

class MyButton: UIButton {
    var url: String?
}

