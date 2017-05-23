//
//  WebViewController.swift
//  YuMoya
//
//  Created by Tsung Han Yu on 2017/3/20.
//  Copyright © 2017年 Tsung Han Yu. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var urlStr = "https://github.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView(urlStr)
    }

    func setupWebView(_ urlStr:String) {
        print(urlStr)
        let url = URL(string:urlStr)!
        let request:URLRequest = URLRequest(url:url)
        webView.loadRequest(request)
        
        webView.scalesPageToFit = true
        
//        webView.delegate = self
    }

}
