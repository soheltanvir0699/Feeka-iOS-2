//
//  ChangePasswordController.swift
//  FEEKA
//
//  Created by Apple Guru on 5/3/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class ChangePasswordController: UIViewController {

    @IBOutlet weak var confirmPass: UITextField!
    @IBOutlet weak var currentPass: UITextField!
    @IBOutlet weak var newPass: UITextField!
    @IBOutlet weak var newImg: UIButton!
    @IBOutlet weak var confirmImg: UIButton!
    @IBOutlet weak var currentImg: UIButton!
    var indicator: NVActivityIndicatorView!
    let userdefault = UserDefaults.standard
    var customerId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if userdefault.value(forKey: "customer_id") != nil {
                   customerId = userdefault.value(forKey: "customer_id") as! String
               }
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func currentSecure(_ sender: Any) {
        if  currentPass.isSecureTextEntry ==  false {
            
        currentImg.setImage(#imageLiteral(resourceName: "not-visible-interface-symbol-of-an-eye-with-a-slash-on-it"), for: .normal)
            currentPass.isSecureTextEntry = true
            
        } else {
            
            currentPass.isSecureTextEntry = false
            currentImg.setImage(#imageLiteral(resourceName: "eye"), for: .normal)
        }
    }
    @IBAction func newPassSecure(_ sender: Any) {
        if  newPass.isSecureTextEntry ==  false {
            
        newImg.setImage(#imageLiteral(resourceName: "not-visible-interface-symbol-of-an-eye-with-a-slash-on-it"), for: .normal)
            newPass.isSecureTextEntry = true
            
        } else {
            
            newPass.isSecureTextEntry = false
            newImg.setImage(#imageLiteral(resourceName: "eye"), for: .normal)
        }
    }
    
    @IBAction func confirmSecure(_ sender: Any) {
        if  confirmPass.isSecureTextEntry ==  false {
            
        confirmImg.setImage(#imageLiteral(resourceName: "not-visible-interface-symbol-of-an-eye-with-a-slash-on-it"), for: .normal)
            confirmPass.isSecureTextEntry = true
            
        } else {
            
            confirmPass.isSecureTextEntry = false
            confirmImg.setImage(#imageLiteral(resourceName: "eye"), for: .normal)
        }
    }
    
    @IBAction func saveAction(_ sender: Any) {
                      indicator = indicator()
                       guard let url = URL(string: "https://feeka.co.za/json-api/route/change_password.php") else {
                           self.showToast(message: "Please try again later")
                           return
                       }
        
        
                       
                       if newPass.text != confirmPass.text {
                                  self.view.makeToast("Password Not Match")
                                  return
                              } else {
                           let paramater = [
                            "customer_id":"\(customerId)",
                            "new_password":"\(newPass.text!)",
                            "old_password":"\(currentPass.text!)"
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
                                   let responseString = NSString(data: result, encoding: String.Encoding.utf8.rawValue)
                                   let jsonRespose = JSON(result)
                                   print(jsonRespose)
                                   print(jsonRespose["message"].stringValue)
                                self.view.makeToast(jsonRespose["message"].stringValue)
                                   if jsonRespose["message"].stringValue == "Please check your email." {
                                       let alert = UIAlertController(title: "Please check your email", message: "", preferredStyle: .alert)
                                       alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                                           self.navigationController?.popViewController(animated: true)
                                       }))
                                      //self.present(alert, animated: true, completion: nil)
                                   } else {
                                       let alert = ShowAlertView().alertView(title: "Invalid email address.", action: "OK", message: "")
                                       self.present(alert, animated: true, completion: nil)
                                   }

                                   self.indicator.stopAnimating()
                               }
                           }
               }
    }
    
}
