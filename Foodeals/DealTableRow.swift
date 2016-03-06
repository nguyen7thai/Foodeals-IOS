//
//  DealTableRow.swift
//  Foodeals
//
//  Created by Thai Nguyen on 3/5/16.
//  Copyright © 2016 Thai Nguyen. All rights reserved.
//

import UIKit

class DealTableRow: UITableViewCell {
    
    func setItem(mapPin: MapPin) {
        self.textLabel?.text = mapPin.dealItem.title
    }
}