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
import IQKeyboardManagerSwift
class AddAddressViewController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var navView: UIView!
    var indicator: NVActivityIndicatorView!
    var dataList = [addressDataModel]()
    let userdefault = UserDefaults.standard
    var customerId = ""
    var isAddress = true
    override func viewDidLoad() {
        super.viewDidLoad()

        
        navView.setShadow()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
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
    
    @objc func editProfile(sender: UIButton) {
        let index = sender.tag - 1000
        let addressDetails = storyboard?.instantiateViewController(withIdentifier: "AddAddressDetailsViewController") as? AddAddressDetailsViewController
        addressDetails!.name = dataList[index].name1
        addressDetails?.sureName = dataList[index].sureName1
        addressDetails?.phone = dataList[index].phone1
        addressDetails?.country = dataList[index].country1
        addressDetails?.streetAdd = dataList[index].streetAdd1
        addressDetails?.suburb = dataList[index].suburb1
        addressDetails?.city = dataList[index].city1
        addressDetails?.postalCode = dataList[index].postalCode1
        addressDetails?.company = dataList[index].company
        addressDetails?.addressId = dataList[index].addressId
        addressDetails?.urlLink = "https://feeka.co.za/json-api/route/edit_address.php"
        //addressDetails?.isAddress = true
        self.navigationController?.pushViewController(addressDetails!, animated: true)
    }
    
    @objc func deleteProfile(sender: UIButton) {
        let index = sender.tag - 2000
               indicator = self.indicator()
//        var address_id = ""
//        if userdefault.value(forKey: "address_id") as? String != nil {
//            address_id = userdefault.value(forKey: "address_id") as! String
//        }
        guard let url = URL(string: "https://feeka.co.za/json-api/route/remove_address.php") else {
                           self.view.makeToast( "Please try again later")
                              return
                          }
                          
                              let paramater = [
                                 
                                "Address_id": "\(dataList[index].addressId)",
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
                                        //self.addressView.isHidden = true
                                        //self.add.isHidden = true
                                       // self.isAddress = true
                                        self.dataList.remove(at: index)
                                        self.tblView.reloadData()
                                      } else {
                                        
                                       // self.addressView.isHidden = false
                                        //self.defaultAddress.isHidden = false
                                        
                                      }

                                      self.indicator.stopAnimating()
                                  }
                              
                  }
        
    }
    
 
    @IBAction func addAddressBtn() {
        let addressDetails = storyboard?.instantiateViewController(withIdentifier: "AddAddressDetailsViewController") as? AddAddressDetailsViewController
       // addressDetails?.isAddress = self.isAddress
        self.navigationController?.pushViewController(addressDetails!, animated: true)
    }
  
    fileprivate func alertView() {
        let alertVc = ShowAlertView().alertView(title: "Please add new address", action: "OK", message: "")
           self.present(alertVc, animated: true, completion: nil)
         }
    
    fileprivate func updateView() {
//        self.name.text = "\(name1) \(sureName1)"
//        self.phoneNumber.text = phone1
//        self.country.text = country1
//        self.homeAdress.text = streetAdd1
//        self.suburb.text = suburb1
//        self.city.text = city1
//        self.postalCode.text = postalCode1
//
//        self.addressView.isHidden = false
//        self.defaultAddress.isHidden = false
    }
    
    func getAddressApi() {
        indicator = self.indicator()
        self.dataList = [addressDataModel]()
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
                                       let data = jsonRespose["data"].arrayValue
                                        for data in data {
                                        let name1 = data["Name"].stringValue
                                        let sureName1 = data["Surname"].stringValue
                                        let phone1 = data["Contact_Number"].stringValue
                                        let country1 = data["Country"].stringValue
                                        let streetAdd1 = data["Street_Address"].stringValue
                                        let suburb1 = data["Suburb"].stringValue
                                        let city1 = data["City"].stringValue
                                        let postalCode1 = data["Postal_Code"].stringValue
                                        let company = data["Company"].stringValue
                                        let addressId = data["address_id"].stringValue
                                        //self.userdefault.setValue(addressId, forKey: "address_id")
                                       // self.updateView(self.name1, self.sureName1, self.phone1, self.country1, self.streetAdd1, self.suburb1, self.city1, self.postalCode1)
                                            
                                        self.dataList.append(addressDataModel(name1: name1, sureName1: sureName1, phone1: phone1, country1: country1, streetAdd1: streetAdd1, suburb1: suburb1, city1: city1, postalCode1: postalCode1, company: company, addressId: addressId))
                                            print(self.dataList)
                                            self.tblView.reloadData()
                                        }
                                       
                                      } else {
                                        
                                        self.alertView()
                                        
                                      }

                                      self.indicator.stopAnimating()
                                  }
                              
                  }
    }
         

}

extension AddAddressViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AddressOneCell
        if dataList.count != 0 {
        cell.name.text = "\(dataList[indexPath.row].name1) \(dataList[indexPath.row].sureName1)"
        cell.phoneNumber.text = dataList[indexPath.row].phone1
        cell.country.text = dataList[indexPath.row].country1
        cell.homeAdress.text = dataList[indexPath.row].streetAdd1
        cell.suburb.text = dataList[indexPath.row].suburb1
        cell.city.text = dataList[indexPath.row].city1
        cell.postalCode.text = dataList[indexPath.row].postalCode1
        }
        cell.editAddress.tag = indexPath.row + 1000
        cell.deleteAddress.tag = indexPath.row + 2000
        cell.deleteAddress.addTarget(self, action: #selector(deleteProfile(sender:)), for: .touchUpInside)
        cell.editAddress.addTarget(self, action: #selector(editProfile(sender:)), for: .touchUpInside)
        if indexPath.row == 0 {
            
        } else if indexPath.row == 1 {
            cell.defaultAddress.text = "OTHER ADDRESS"
        } else {
            cell.defaultAddress.isHidden = true
        }
        return cell
    }
    
    
}
