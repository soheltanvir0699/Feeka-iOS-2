//
//  TabViewController.swift
//  FEEKA
//
//  Created by Apple Guru on 29/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        bagApiCalling()
    }

 @objc func bagApiCalling() {
              guard let urlToExcute = URL(string: "https://feeka.co.za/json-api/route/view_to_cart_v4.php") else {
                  return
              }
              let userdefault = UserDefaults.standard
              var customerId = ""
           
       //    if  userdefault.value(forKey: "customer_id") as! String != "" {
       //        customerId = userdefault.value(forKey: "customer_id") as! String
       //    }
           
           if userdefault.value(forKey: "customer_id") as? String != nil {
               customerId = userdefault.value(forKey: "customer_id") as! String
           } else {
               
           }
              
              let parameter = ["customer_id":"\(customerId)"]
              
              Alamofire.request(urlToExcute, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
              
              if let error = response.error {
                  print(error)
                  
              }
              
                  if let response = response.result.value {
                      let jsonResponse = JSON(response)
                                        
                          let data = jsonResponse["data"].arrayValue
                      
                      
                      if let tabItems = self.tabBarController?.tabBar.items {
                                     
                                     let tabItem = tabItems[2]
                                     tabItem.badgeValue = "\(data.count)"
                                 }
                  
                  }
                  
              }
          }
           

}
