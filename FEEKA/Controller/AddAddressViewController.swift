//
//  AddAddressViewController.swift
//  FEEKA
//
//  Created by Al Mujahid Khan on 2/16/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
class AddAddressViewController: UIViewController {

    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var defaultAddress: UILabel!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var homeAdress: UILabel!
    @IBOutlet weak var suburb: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var postalCode: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var editAddress: UIImageView!
    
    @IBOutlet weak var deleteAddress: UIImageView!
    var indicator: NVActivityIndicatorView!
    var name1 = ""
    var sureName1 = ""
    var phone1 = ""
    var country1 = ""
    var streetAdd1 = ""
    var suburb1 = ""
    var city1 = ""
    var postalCode1 = ""
    var company = ""
    let userdefault = UserDefaults.standard
    var customerId = ""
    var isAddress = true
    override func viewDidLoad() {
        super.viewDidLoad()

        
        editAddress.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editProfile)))
        deleteAddress.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteProfile)))
        navView.setShadow()
        addressView.setShadow()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if userdefault.value(forKey: "customer_id") != nil {
            customerId = userdefault.value(forKey: "customer_id") as! String
        }
        getAddressApi()
    }
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func editProfile() {
        let addressDetails = storyboard?.instantiateViewController(withIdentifier: "AddAddressDetailsViewController") as? AddAddressDetailsViewController
        addressDetails!.name = name1
        addressDetails?.sureName = sureName1
        addressDetails?.phone = phone1
        addressDetails?.country = country1
        addressDetails?.streetAdd = streetAdd1
        addressDetails?.suburb = suburb1
        addressDetails?.city = city1
        addressDetails?.postalCode = postalCode1
        addressDetails?.company = company
        addressDetails?.addressId = userdefault.value(forKey: "address_id") as! String
        addressDetails?.urlLink = "https://feeka.co.za/json-api/route/edit_address.php"
        addressDetails?.isAddress = true
        self.navigationController?.pushViewController(addressDetails!, animated: true)
    }
    
    @objc func deleteProfile() {
        indicator = self.indicator()
        let address_id = userdefault.value(forKey: "address_id") as! String
        guard let url = URL(string: "https://feeka.co.za/json-api/route/remove_address.php") else {
                           self.view.makeToast( "Please try again later")
                              return
                          }
                          
                              let paramater = [
                                 
                                 "Address_id": "\(address_id)",
                                 "customer_id": "\(customerId)",
                                 "is_default":"1"
                                 
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
                                        self.addressView.isHidden = true
                                        self.defaultAddress.isHidden = true
                                        self.isAddress = true
                                      } else {
                                        
                                        self.addressView.isHidden = false
                                        self.defaultAddress.isHidden = false
                                        
                                      }

                                      self.indicator.stopAnimating()
                                  }
                              
                  }
    }
    
 
    @IBAction func addAddressBtn(_ sender: Any) {
        let addressDetails = storyboard?.instantiateViewController(withIdentifier: "AddAddressDetailsViewController") as? AddAddressDetailsViewController
        addressDetails?.isAddress = self.isAddress
        self.navigationController?.pushViewController(addressDetails!, animated: true)
    }
  
    fileprivate func alertView() {
        let alertVc = ShowAlertView().alertView(title: "Please add new address", action: "OK", message: "")
           self.present(alertVc, animated: true, completion: nil)
         }
    
    fileprivate func updateView(_ name: String, _ sureName: String, _ phone: String, _ country: String, _ streetAdd: String, _ suburb: String, _ city: String, _ postalCode: String) {
        self.name.text = "\(name1) \(sureName1)"
        self.phoneNumber.text = phone1
        self.country.text = country1
        self.homeAdress.text = streetAdd1
        self.suburb.text = suburb1
        self.city.text = city1
        self.postalCode.text = postalCode1
        
        self.addressView.isHidden = false
        self.defaultAddress.isHidden = false
    }
    
    func getAddressApi() {
        indicator = self.indicator()
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
                                        self.isAddress = false
                                       let data = jsonRespose["data"].arrayValue[0]
                                        self.name1 = data["Name"].stringValue
                                        self.sureName1 = data["Surname"].stringValue
                                        self.phone1 = data["Contact_Number"].stringValue
                                        self.country1 = data["Country"].stringValue
                                        self.streetAdd1 = data["Street_Address"].stringValue
                                        self.suburb1 = data["Suburb"].stringValue
                                        self.city1 = data["City"].stringValue
                                        self.postalCode1 = data["Postal_Code"].stringValue
                                        self.company = data["Company"].stringValue
                                        let addressId = data["address_id"].stringValue
                                        self.userdefault.setValue(addressId, forKey: "address_id")
                                        self.updateView(self.name1, self.sureName1, self.phone1, self.country1, self.streetAdd1, self.suburb1, self.city1, self.postalCode1)
                                       
                                      } else {
                                        
                                        self.alertView()
                                        self.addressView.isHidden = true
                                        self.defaultAddress.isHidden = true
                                        
                                      }

                                      self.indicator.stopAnimating()
                                  }
                              
                  }
    }
         

}
