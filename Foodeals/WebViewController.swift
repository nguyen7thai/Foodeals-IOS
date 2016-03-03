//
//  WebViewController.swift
//  Foodeals
//
//  Created by Thai Nguyen on 2/25/16.
//  Copyright © 2016 Thai Nguyen. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    var url: String?
    
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let nsurl = NSURL (string: url!)
        print(url)
        let requestObj = NSURLRequest(URL: nsurl!)
        webView.loadRequest(requestObj)
    }
}