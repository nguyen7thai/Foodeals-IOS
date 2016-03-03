//
//  DealItem.swift
//  Foodeals
//
//  Created by Thai Nguyen on 2/23/16.
//  Copyright © 2016 Thai Nguyen. All rights reserved.
//

import Foundation
import MapKit

class DealItem: NSObject {
    let title: String
    let address: String
    let lat: CLLocationDegrees
    let long: CLLocationDegrees
    let url: String
    
    init(dict: [String:AnyObject]) {
        title = dict["title"] as! String
        address = dict["address"] as! String
        lat = CLLocationDegrees(dict["lat"] as! String)!
        long = CLLocationDegrees(dict["long"] as! String)!
        url = dict["url"] as! String
    }
}
