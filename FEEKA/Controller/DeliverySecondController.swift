//
//  DeliverySecondController.swift
//  FEEKA
//
//  Created by Apple Guru on 25/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class DeliverySecondController: UIViewController {
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var standarLbl: UILabel!
    var addressId = ""
    var customerId = ""
    let userdefault = UserDefaults.standard
    var indicator:NVActivityIndicatorView!
    
    @IBOutlet weak var priceLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        navView.setShadow()
        detailsView.setShadow()
             
    }
    
    override func viewWillAppear(_ animated: Bool) {
                 if  userdefault.value(forKey: "address_id") as! String != "" {
                         addressId = userdefault.value(forKey: "address_id") as! String
                     }
                     
                     if userdefault.value(forKey: "address_id") as? String == nil {
                         addressId = userdefault.value(forKey: "address_id") as! String
                     }
              
              if  userdefault.value(forKey: "customer_id") as! String != "" {
                  customerId = userdefault.value(forKey: "customer_id") as! String
              }
              
              if userdefault.value(forKey: "customer_id") as? String == nil {
                  customerId = userdefault.value(forKey: "customer_id") as! String
              }
        
              deliveryQuoteApi()
    }
    
    @IBAction func continueToPayAction(_ sender: Any) {
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func deliveryQuoteApi() {
       
               indicator = self.indicator()
               indicator.startAnimating()
              
               guard let url = URL(string: "https://feeka.co.za/json-api/route/get_delivery_quote.php") else {
                                  self.view.makeToast( "Please try again later")
                                     return
                                 }
                                 
                                     let paramater = [
                                        
                                        "address_id": "\(self.addressId)",
                                        "customer_id": "\(self.customerId)"
                                     ]
        print(paramater)
                                     Alamofire.request(url, method: .post, parameters: paramater, encoding: JSONEncoding.default, headers: nil).response { (response) in
                                         self.indicator.startAnimating()
                                         if let error = response.error {
                                             self.indicator.stopAnimating()
                                             let alertView = ShowAlertView().alertView(title: "Something went wrong", action: "OK", message: "Please try again.")
                                             self.present(alertView, animated: true, completion: nil)
                                             print(error)
                                             
                                         }
                                         
                                         if let result = response.data {
                                             let jsonRespose = JSON(result)
                                            print(jsonRespose)
                                             if jsonRespose["status"].stringValue == "ok" {
                                               
                                                let data = jsonRespose["data"].arrayValue
                                                let jsonData = JSON(data[0])
                                                let deliveryCost = jsonData["delivery_cost"].stringValue
                                                let quote = jsonData["delivery_quote"].stringValue
                                                self.standarLbl.text = quote
                                                self.priceLbl.text = "R \(deliveryCost)"
                                               
                                             } else {
                                               
                                                let alert = UIAlertController(title: "", message: "Something Wrong", preferredStyle: .alert)
                                                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                                                    self.dismiss(animated: true, completion: nil)
                                                }))
                                              
                                                self.present(alert, animated: true, completion: nil)
                                                //self.defaultAddress.isHidden = false
                                               
                                             }

                                             self.indicator.stopAnimating()
                                         }
                                     
                         
           }
           
    }
    
    

}
