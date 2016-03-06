//
//  MapPin.swift
//  Foodeals
//
//  Created by Thai Nguyen on 3/1/16.
//  Copyright © 2016 Thai Nguyen. All rights reserved.
//

import Foundation
import MapKit

class MapPin: MKPointAnnotation {
    var dealUrl: String?
    var dealItem: DealItem!
    
    func location() -> CLLocation {
        return CLLocation(latitude: dealItem.lat, longitude: dealItem.long)
    }
}

class MyButton: UIButton {
    var url: String?
}