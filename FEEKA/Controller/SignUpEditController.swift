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
import PopupDialog
import IQKeyboardManagerSwift

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
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
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

                    //self.hideKeyBoard()
                    textField.resignFirstResponder()

                  }
                  let menAction = UIAlertAction(title: "Male", style: .default) { (_) in
                      textField.text = "Male"
                    //self.hideKeyBoard()
                    textField.resignFirstResponder()
                  }
            let cancel = UIAlertAction(title: "", style: .default) { (_) in
                //textField.text = "Male"
                //self.hideKeyBoard()
                textField.resignFirstResponder()

            }

                  alert.addAction(womenAction)
                  alert.addAction(menAction)
                  alert.addAction(cancel)
                  self.present(alert, animated: true, completion: nil)
            
//            let title = "THIS IS THE DIALOG TITLE"
//            let message = "This is the message section of the popup dialog default view"
////let image = UIImage(named: "pexels-photo-103290")
//
//            // Create the dialog
//            let popup = PopupDialog(title: "SELECT GENDER", message: "")
//
//            // Create buttons
//            let buttonOne = CancelButton(title: "CANCEL") {
//                print("You canceled the car dialog.")
//            }
//
//            // This button will not the dismiss the dialog
//            let buttonTwo = DefaultButton(title: "MALE", dismissOnTap: true) {
//                print("What a beauty!")
//
//                textField.text = "Male"
//            }
//
//            let buttonThree = DefaultButton(title: "FEMALE", dismissOnTap: true) {
//                textField.text =  "Female"
//                self.removeFromParent()
//                print("What a beauty!")
//            }
//
//            let pv = PopupDialogDefaultView.appearance()
//            pv.titleFont    = UIFont(name: "HelveticaNeue-Light", size: 16)!
//            pv.titleColor   = .white
//            pv.messageFont  = UIFont(name: "HelveticaNeue", size: 14)!
//            pv.messageColor = UIColor(white: 0.8, alpha: 1)
//
//            // Customize the container view appearance
//            let pcv = PopupDialogContainerView.appearance()
//            pcv.backgroundColor = UIColor(red:0.23, green:0.23, blue:0.27, alpha:1.00)
//            pcv.cornerRadius    = 2
//            pcv.shadowEnabled   = true
//            pcv.shadowColor     = .black
//
//            // Customize overlay appearance
//            let ov = PopupDialogOverlayView.appearance()
//            ov.blurEnabled     = true
//            ov.blurRadius      = 30
//            ov.liveBlurEnabled = true
//            ov.opacity         = 0.7
//            ov.color           = .black
//
//            // Customize default button appearance
//            let db = DefaultButton.appearance()
//            buttonTwo.titleFont      = UIFont(name: "HelveticaNeue-Medium", size: 14)!
//            buttonTwo.titleColor     = .white
//            buttonTwo.buttonColor    = UIColor(red:0.25, green:0.25, blue:0.29, alpha:1.00)
//            buttonTwo.separatorColor = UIColor(red:0.20, green:0.20, blue:0.25, alpha:1.00)
//
//            // Customize cancel button appearance
//            let cb = CancelButton.appearance()
//            buttonTwo.titleFont      = UIFont(name: "HelveticaNeue-Medium", size: 14)!
//            buttonTwo.titleColor     = UIColor(white: 0.6, alpha: 1)
//            buttonTwo.buttonColor    = UIColor(red:0.25, green:0.25, blue:0.29, alpha:1.00)
//            buttonTwo.separatorColor = UIColor(red:0.20, green:0.20, blue:0.25, alpha:1.00)
//
//            // Add buttons to dialog
//            // Alternatively, you can use popup.addButton(buttonOne)
//            // to add a single button
//            popup.addButtons([ buttonTwo, buttonThree, buttonOne])

            // Present dialog
           // self.present(popup, animated: true, completion: nil)
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
     dateFormatter.dateFormat = "yyyy-MM-dd"
     birthDate.text       = dateFormatter.string(from: datePicker.date)
     self.view.endEditing(true)
 }
    
    
       func getAddressApi() {
           indicator = self.indicator()
        indicator.startAnimating()
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
                                          
                                          let data = JSON(jsonRespose["data"])
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
        indicator.startAnimating()
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
