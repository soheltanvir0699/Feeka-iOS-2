//
//  EditChangeAddressController.swift
//  FEEKA
//
//  Created by Apple Guru on 25/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class EditChangeAddressController: UIViewController {

    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var contact: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var apartment: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var street: UILabel!
    @IBOutlet weak var suburb: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var postalCode: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var deleteBtn: UIImageView!
    @IBOutlet weak var editAction: UIImageView!
    @IBOutlet weak var addressView: UIView!
    
    let userdefault = UserDefaults.standard
    var dataList = [getCustomerDataModel]()
    var isAddress = true
    var customerId = ""
    var indicator:NVActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if userdefault.value(forKey: "customer_id") as? String == nil {
            customerId = userdefault.value(forKey: "customer_id") as! String
        }
        setUpView()
        getAddressApi()
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setUpView() {
        navView.setShadow()
        addressView.setShadow()
        deleteBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteAdress)))
        editAction.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editAdress)))
    }
    
  @objc func deleteAdress(){
        deleteProfile()
    }
    
    @objc func editAdress() {
        editProfile()
        
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func editProfile() {
        let addressDetails = storyboard?.instantiateViewController(withIdentifier: "AddAddressDetailsViewController") as? AddAddressDetailsViewController
        addressDetails!.name = dataList[0].name
        addressDetails?.sureName = dataList[0].surname
        addressDetails?.phone = dataList[0].contactNumber
        addressDetails?.country = dataList[0].country
        addressDetails?.streetAdd = dataList[0].street
        addressDetails?.suburb = dataList[0].suburb
        addressDetails?.city = dataList[0].city
        addressDetails?.postalCode = dataList[0].postalCode
        addressDetails?.company = dataList[0].company
        addressDetails?.addressId = userdefault.value(forKey: "address_id") as! String
        addressDetails?.urlLink = "https://feeka.co.za/json-api/route/edit_address.php"
        addressDetails?.isAddress = true
        addressDetails?.modalPresentationStyle = .fullScreen
        self.present(addressDetails!, animated: true, completion: nil)
    }
    
    
    
    @objc func deleteProfile() {
        indicator = self.indicator()
        var address_id = ""
        if userdefault.value(forKey: "address_id") as? String != nil {
            address_id = userdefault.value(forKey: "address_id") as! String
        }
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
                                        //self.add.isHidden = true
                                        self.isAddress = true
                                      } else {
                                        
                                        self.addressView.isHidden = false
                                        //self.defaultAddress.isHidden = false
                                        
                                      }

                                      self.indicator.stopAnimating()
                                  }
                              
                  }
    }
    
    
    func getAddressApi() {
        indicator = self.indicator()
        self.dataList = [getCustomerDataModel]()
        indicator.startAnimating()
        guard let urlToExcute = URL(string: "https://feeka.co.za/json-api/route/get_address.php") else {
            return
        }
        
        
        let parameter = ["customer_id":"\(self.customerId)"]
        
        
        Alamofire.request(urlToExcute, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
        
        if let error = response.error {
            self.indicator.stopAnimating()
            let alertView = ShowAlertView().alertView(title: "Something went wrong", action: "OK", message: "Please try again.")
            self.present(alertView, animated: true, completion: nil)
            print(error)
            
        }
        
            if let response = response.result.value {
                let jsonResponse = JSON(response)
                                  
                if jsonResponse["status"].stringValue == "1" {
                    let data = jsonResponse["data"].arrayValue[0]
                    if data.isEmpty == false {
                        let address = data["address_id"].stringValue
                        let customerid = data["customer_id"].stringValue
                        let name = data["Name"].stringValue
                        let surname = data["Surname"].stringValue
                        let apartment = data["Apartment"].stringValue
                        let company = data["Company"].stringValue
                        let streetAddress = data["Street_Address"].stringValue
                        let suburb = data["Suburb"].stringValue
                        let city = data["City"].stringValue
                        let country = data["Country"].stringValue
                        let postalCode = data["Postal_Code"].stringValue
                        let contact = data["Contact_Number"].stringValue
                        let unit = data["Unit_Number"].stringValue
                        self.userdefault.setValue(address, forKey: "address_id")
                        self.dataList.append(getCustomerDataModel(addressId: address, customerId: customerid, name: name, surname: surname, apartment: apartment, company: company, street: streetAddress, suburb: suburb, city: city, country: country, postalCode: postalCode, contactNumber: contact))
                        self.postalCode.text = postalCode
                        self.name.text = "\(name) \(surname)"
                        self.contact.text = contact
                        self.apartment.text = "\(unit) \(apartment)"
                        self.company.text = company
                        self.street.text = streetAddress
                        self.suburb.text = suburb
                        self.city.text = city
                        self.country.text = country
                        self.isAddress = false
                        self.addressView.isHidden = false
                        self.indicator.stopAnimating()
                    }
                } else {
                    self.view.makeToast("Address Not Found")
                    self.addressView.isHidden = true
                    self.isAddress = true
                    self.indicator.stopAnimating()
                }
              
            
            }else {
              let alertView = ShowAlertView().alertView(title: "No Product Found", action: "OK", message: "")
                self.indicator.stopAnimating()
              self.present(alertView, animated: true, completion: nil)
          }
            
        }
    }

}
