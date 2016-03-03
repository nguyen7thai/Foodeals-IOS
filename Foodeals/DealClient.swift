//
//  DealClient.swift
//  Foodeals
//
//  Created by Thai Nguyen on 2/23/16.
//  Copyright © 2016 Thai Nguyen. All rights reserved.
//

import Foundation

class DealClient: NSObject {
    func getDeals(handler: (data: [DealItem]?, error: NSError?) -> Void) {
        let dataURL = NSURL(string: "https://foodeals.herokuapp.com/deal_items")!
        let task = NSURLSession.sharedSession().dataTaskWithURL(dataURL) { (data, response, error) in
            if error == nil {
                do {
                    let data = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    let dealItemsRaw = data["deal_items"] as! [[String:AnyObject]]
                    var dealItems = [DealItem]()
                    for dict in dealItemsRaw {
                        dealItems.append(DealItem(dict: dict))
                    }
                    handler(data: dealItems, error: nil)
                } catch {
                    handler(data: nil, error: NSError(domain: "getDeals", code: 1, userInfo: nil))
                }
            } else {
                handler(data: nil, error: error)
            }
            
        }
        task.resume()
    }
}

