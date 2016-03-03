//
//  GCDBlackBox.swift
//  Foodeals
//
//  Created by Thai Nguyen on 2/23/16.
//  Copyright © 2016 Thai Nguyen. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}