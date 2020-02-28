//
//  SignUpEditController.swift
//  FEEKA
//
//  Created by Apple Guru on 28/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class SignUpEditController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var editbtn: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var birthDate: UITextField!
    @IBOutlet weak var sureName: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var gender: UITextField!
    
    @IBOutlet weak var emailImg: UIImageView!
    var names = ""
    var bithdays = ""
    
    var surenames = ""
    var genders = ""
    var emails = ""
    var customerId = ""
    
    var indicator: NVActivityIndicatorView!
    var isEdit = true
    
    let userdefault = UserDefaults.standard
     var datePicker = UIDatePicker()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.\
        if userdefault.value(forKey: "customer_id") != nil {
                   customerId = userdefault.value(forKey: "customer_id") as! String
               }
        birthDate.delegate = self
        creatDatePicker()
        gender.delegate = self
        
        getAddressApi()
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func editBtn(_ sender: Any) {
        if isEdit == true {
            isEdit = false
            email.isHidden = true
            emailImg.isHidden = true
            editbtn.setTitle("SAVE", for: .normal)
        }else {
            isEdit = true
            email.isHidden = true
            emailImg.isHidden = true
            editbtn.setTitle("EDIT", for: .normal)
            SaveAddressApi()
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 10 {
        textField.inputView = UIView()
          let alert = UIAlertController(title: "Select Gender", message: nil, preferredStyle: .actionSheet)
                  let womenAction = UIAlertAction(title: "Female", style: .default) { (women) in
                      textField.text =  "Female"
                    
                      
                  
                  }
                  let menAction = UIAlertAction(title: "Male", style: .default) { (_) in
                      textField.text = "Male"
                     
                  }
                 
                  alert.addAction(womenAction)
                  alert.addAction(menAction)
                  self.present(alert, animated: true, completion: nil)
        }
    }
 func creatDatePicker() {
     
     datePicker.backgroundColor = .gray
     datePicker.tintColor       = .white
     datePicker.datePickerMode  = .date
     birthDate.inputView    = datePicker
     
     let toolbar             = UIToolbar()
     toolbar.sizeToFit()
     toolbar.backgroundColor = .darkGray
     toolbar.tintColor       = .black
     
     let donebutton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneClicked))
     toolbar.setItems([donebutton], animated: true)
     birthDate.inputAccessoryView = toolbar
     
 }
 
 @objc func doneClicked() {
     let dateFormatter        = DateFormatter()
     dateFormatter.dateFormat = "dd-MM-yyyy"
     birthDate.text       = dateFormatter.string(from: datePicker.date)
     self.view.endEditing(true)
 }
    
    
       func getAddressApi() {
           indicator = self.indicator()
           guard let url = URL(string: "https://feeka.co.za/json-api/route/customer_detail.php") else {
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
                                          
                                          let data = jsonRespose["data"].arrayValue[0]
                                            self.name.text = data["first_name"].stringValue
                                            self.sureName.text = data["last_name"].stringValue
                                            self.birthDate.text = data["DOB"].stringValue
                                            self.gender.text = data["Gender"].stringValue
                                            self.email.text = data["user_email"].stringValue
                                            
                                            self.names = data["first_name"].stringValue
                                            self.surenames = data["last_name"].stringValue
                                            self.bithdays = data["DOB"].stringValue
                                            self.genders = data["Gender"].stringValue
                                            self.emails = data["user_email"].stringValue
                                            
                                           
                                          
                                         } else {
                                           
                                         
                                           
                                         }

                                         self.indicator.stopAnimating()
                                     }
                                 
                     }
       }

    func SaveAddressApi() {
              indicator = self.indicator()
              guard let url = URL(string: "https://feeka.co.za/json-api/route/edit_profile.php") else {
                                 self.view.makeToast( "Please try again later")
                                    return
                                }
                                
                                    let paramater = [
                                        "customer_id":"\(customerId)","DOB":"\(birthDate.text!)","email_address":"","first_name":"\(name.text!)","gender":"\(gender.text!)","last_name":"\(sureName.text!)"
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
                                                 self.indicator.stopAnimating()
                                                self.navigationController?.popViewController(animated: true)
                                             
                                              
                                             
                                            } else {
                                              
                                            
                                              
                                            }

                                            self.indicator.stopAnimating()
                                        }
                                    
                        }
          }
}
