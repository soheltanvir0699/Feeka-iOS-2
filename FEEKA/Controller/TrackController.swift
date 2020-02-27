//
//  TrackController.swift
//  FEEKA
//
//  Created by Apple Guru on 26/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class TrackController: UIViewController {

    @IBOutlet weak var orderId: UILabel!
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var scheduled: UILabel!
    @IBOutlet weak var contact: UILabel!
    @IBOutlet weak var street: UILabel!
    @IBOutlet weak var apartment: UILabel!
    @IBOutlet weak var postal: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var currenStatus: UILabel!
    @IBOutlet weak var name: UILabel!
    var indicator:NVActivityIndicatorView!
    var customerId = ""
    var orderIdTxt = ""
    let userdefault = UserDefaults.standard
    var dataList = [orderModel]()
    var date = [String]()
    var tempdescription = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.orderId.text = orderIdTxt
        if dataList.isEmpty != true {
        
        self.name.text = "\(StoredProperty.addressData[0].name) \(StoredProperty.addressData[0].surname)"
        self.contact.text = StoredProperty.addressData[0].contactNumber
        self.street.text = StoredProperty.addressData[0].street
        self.apartment.text = StoredProperty.addressData[0].apartment
        self.postal.text = StoredProperty.addressData[0].postalCode
        self.country.text = StoredProperty.addressData[0].country
        }
        //self.contact.text = StoredProperty.addressData[0].contactNumber
       if userdefault.value(forKey: "customer_id") as? String != nil {
           customerId = userdefault.value(forKey: "customer_id") as! String
       }
        
      ordersApi()
      getAddressApi()
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func getAddressApi() {
        //indicator = self.indicator()
        guard let url = URL(string: "https://feeka.co.za/json-api/route/get_address.php") else {
                           self.view.makeToast( "Please try again later")
                              return
                          }
                          
                              let paramater = [
                                 "customer_id":"\(customerId)"
                              ]
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
                                     
                                      if jsonRespose["status"].stringValue == "1" {
                                        //self.isAddress = false
                                       let data = jsonRespose["data"].arrayValue[0]
                                        self.name.text = "\(data["Name"].stringValue) \(data["Surname"].stringValue)"
                                       // self.sureName1 = data["Surname"].stringValue
                                        self.contact.text = data["Contact_Number"].stringValue
                                        self.country.text = data["Country"].stringValue
                                        self.street.text = data["Street_Address"].stringValue
                                        //self.suburb1 = data["Suburb"].stringValue
                                        self.apartment.text = data["City"].stringValue
                                        self.postal.text = data["Postal_Code"].stringValue
                                       // self. = data["Company"].stringValue
                                        let addressId = data["address_id"].stringValue
                                        self.userdefault.setValue(addressId, forKey: "address_id")
                                        //self.updateView(self.name1, self.sureName1, self.phone1, self.country1, self.streetAdd1, self.suburb1, self.city1, self.postalCode1)
                                       
                                      } else {
                                        
                                       // self.alertView()
                                        //self.addressView.isHidden = true
                                       // self.defaultAddress.isHidden = true
                                        
                                      }

                                    //  self.indicator.stopAnimating()
                                  }
                              
                  }
    }
    
    func ordersApi() {
           
       indicator = self.indicator()
              indicator.startAnimating()
              guard let urlToExcute = URL(string: "https://feeka.co.za/json-api/route/get_tracking_details_v2.php") else {
                  return
              }
           let parameter   = ["customer_id":"\(self.customerId)"]
           
              
              Alamofire.request(urlToExcute, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
              
              if let error = response.error {
                  self.indicator.stopAnimating()
                  let alertView = ShowAlertView().alertView(title: "Something went wrong", action: "OK", message: "Please try again.")
                  self.present(alertView, animated: true, completion: nil)
                  print(error)
                  
              }
//              let alertView = ShowAlertView().alertView(title: "Order Status Not Found", action: "OK", message: "")
//              self.present(alertView, animated: true, completion: nil)
                  if let response = response.result.value {
                      let jsonResponse = JSON(response)
                                        
                   let data =  jsonResponse["data"].arrayValue
                   print(data)
                   print(parameter)
                   if data.isEmpty == true {
                       let alert = UIAlertController(title: "", message: "No Orders Found", preferredStyle: .alert)
                       alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                           self.dismiss(animated: true, completion: nil)
                           NotificationCenter.default.post(name: Notification.Name("backWeb"), object: nil, userInfo: nil)
                       }))
                       
                       self.present(alert, animated: true, completion: nil)
                   }
                   
                   if jsonResponse["status"].stringValue == "1" {
                       for dataItem in data {
                        let dataIndex = JSON(dataItem)
                           let date = dataIndex["description"].stringValue
                        self.date.append(date)
                           let timeStamp = dataIndex["timestamp"].stringValue
                        self.tempdescription.append(timeStamp)
                        
                        self.tblView.reloadData()
                       }
                   } else {
                       let alertView = ShowAlertView().alertView(title: "Something went wrong", action: "OK", message: "")
                       self.present(alertView, animated: true, completion: nil)
                   }
                          self.indicator.stopAnimating()
                      
                  
              }
          }
       
       
       }
       
    
}

extension TrackController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tempdescription.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TruckerCell
        cell?.descripTion.text = tempdescription[indexPath.row]
        cell?.timeStamp.text = date[indexPath.row]
        return cell!
    }
    
    
}
