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
import SDWebImage
import Nuke

class EditChangeAddressController: UIViewController {

    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var tblView: UITableView!
    
    
    let userdefault = UserDefaults.standard
    var dataList = [getCustomerDataModel]()
    var isAddress = true
    var customerId = ""
    var isSelected = 0
    var isSelected2 = 0
    var isWorking = false
    var indicator:NVActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if userdefault.value(forKey: "customer_id") as? String != nil {
            customerId = userdefault.value(forKey: "customer_id") as! String
        }
        setUpView()
        getAddressApi()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func setUpView() {
        navView.setShadow()
    }
    
    
    @IBAction func confirmAction(_ sender: Any) {
        StoredProperty.indexSelectedAddress = isSelected
        StoredProperty.indexSelectedAddressList = self.dataList
        NotificationCenter.default.post(name: Notification.Name("confirmReload"), object: nil)
        
        navigationController?.popViewController(animated: true)
       // dismiss(animated: true, completion: nil)
    }
    
 
    
     
        @objc func editProfile(sender: UIButton) {
            let index = sender.tag - 1000
            let addressDetails = storyboard?.instantiateViewController(withIdentifier: "AddAddressDetailsViewController") as? AddAddressDetailsViewController
            addressDetails!.name = dataList[index].name
            addressDetails?.sureName = dataList[index].surname
            addressDetails?.phone = dataList[index].contactNumber
            addressDetails?.country = dataList[index].country
            addressDetails?.streetAdd = dataList[index].street
            addressDetails?.suburb = dataList[index].suburb
            addressDetails?.city = dataList[index].city
            addressDetails?.postalCode = dataList[index].postalCode
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
                                            self.dataList.remove(at: index)
                                            self.tblView.reloadData()
                                          } else {
                                        
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
        
        print(parameter)
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
                    let data1 = jsonResponse["data"].arrayValue
                    for i in data1 {
                    let data = JSON(i)
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
                        self.tblView.reloadData()
                        self.indicator.stopAnimating()
                        }
                } else {
                    self.view.makeToast("Address Not Found")
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
    
    @objc func selectedAction(sender:UIButton) {
        
        DispatchQueue.main.async {
            
        if sender.tag - 3000 != self.isSelected {
            if let btn =  self.view.viewWithTag(self.isSelected + 3000) as? UIButton {
            btn.setImage(UIImage(named: "radio-inactive"), for: .normal)
            }
              sender.setImage(UIImage(named: "radio-active"), for: .normal)
            self.isSelected = sender.tag - 3000
            self.isSelected2 = sender.tag - 3000
            self.isWorking = true
              
        } else {
        sender.setImage(UIImage(named: "radio-active"), for: .normal)
    }
        }

}
}

extension EditChangeAddressController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! EditChangeAddressCell
        cell.name.text = "\(dataList[indexPath.row].name) \(dataList[indexPath.row].surname)"
        cell.contact.text = dataList[indexPath.row].contactNumber
        cell.country.text = dataList[indexPath.row].country
        cell.street.text = dataList[indexPath.row].street
        cell.suburb.text = dataList[indexPath.row].suburb
        cell.city.text = dataList[indexPath.row].city
        cell.postalCode.text = dataList[indexPath.row].postalCode
        cell.company.text = dataList[indexPath.row].company
        cell.addressView.layer.borderColor = UIColor.gray.cgColor
        cell.addressView.layer.borderWidth = 1
        cell.editActionBtn.tag = indexPath.row + 1000
        cell.deleteBtn.tag = indexPath.row + 2000
        cell.selectionBtn.tag = indexPath.row + 3000
        if isSelected2 == indexPath.row {
            cell.selectionBtn.setImage(UIImage(named: "radio-active"), for: .normal)
            
        }else {
            cell.selectionBtn.setImage(UIImage(named: "radio-inactive"), for: .normal)
        }
        cell.deleteBtn.addTarget(self, action: #selector(deleteProfile(sender:)), for: .touchUpInside)
        cell.selectionBtn.addTarget(self, action: #selector(selectedAction(sender:)), for: .touchUpInside)
        cell.editActionBtn.addTarget(self, action: #selector(editProfile(sender:)), for: .touchUpInside)
       
        return cell
    }
    
    
    
    
}

