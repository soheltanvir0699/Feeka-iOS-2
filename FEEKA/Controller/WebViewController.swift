//
//  WebViewController.swift
//  FEEKA
//
//  Created by Apple Guru on 26/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate{

    @IBOutlet weak var webView: WKWebView!
    var currentUrl = ""
    var cancleUrl = ""
    var successUrl = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
       let url = URL(string: currentUrl)
        let urlReq = URLRequest(url: url!)
        webView.load(urlReq)
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let cancleUrl1 = URL(string: cancleUrl)
        let successUrl1 = URL(string: successUrl)
        if  webView.url == successUrl1 {
            print(webView.url!)
            let ordersAndReturnVC = storyboard?.instantiateViewController(withIdentifier: "OrdersAndReturnController")
            present(ordersAndReturnVC!, animated: true, completion: nil)
        }else if webView.url == cancleUrl1 {
            dismiss(animated: true, completion: nil)
        } else {
            print("error")
        }
    }
}
