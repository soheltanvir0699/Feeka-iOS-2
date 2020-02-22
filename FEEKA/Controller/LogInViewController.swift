//
//  ViewController.swift
//  FEEKA
//
//  Created by Apple Guru on 11/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class LogInViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var hideShowBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var singUpStringLabel: UILabel!
    var ishidePassword = false
    var indicator:NVActivityIndicatorView!
    var userdefault = UserDefaults.standard
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        indicator = self.indicator()
            }
    
    @IBAction func hideShowAction(_ sender: Any) {
        
        if ishidePassword {
            
        hideShowBtn.setImage(#imageLiteral(resourceName: "not-visible-interface-symbol-of-an-eye-with-a-slash-on-it"), for: .normal)
            passwordField.isSecureTextEntry = true
            ishidePassword = false
            
        } else {
            
            passwordField.isSecureTextEntry = false
            ishidePassword = true
            hideShowBtn.setImage(#imageLiteral(resourceName: "eye"), for: .normal)
        }
    }
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
        
        let forgotVC = storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(forgotVC, animated: true)
    }
    
    fileprivate func setUpView() {
        
          singUpStringLabel.text = "Don't have an account yet? \nSign up here"
          facebookBtn.layer.cornerRadius = 10
          signInBtn.layer.cornerRadius = 5
          signUpBtn.layer.cornerRadius = 5
        signUpBtn.addTarget(self, action: #selector(signUpAction), for: .primaryActionTriggered)
      }
    
    @objc func signUpAction() {
        let signUpVC = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @IBAction func loginWithFacebook(_ sender: Any) {
        self.facebookAuth()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logIn(_ sender: Any) {
        
        guard let password = passwordField.text, let email = emailField.text else {
                       self.showToast(message: "Please fill all Field")
                       return
                   }
                   guard let url = URL(string: "https://feeka.co.za/json-api/route/Login_Registration.php") else {
                    self.view.makeToast( "Please try again later")
                       return
                   }
                   
                   if  password == "" || email == "" {
                    self.view.makeToast( "Please fill all Field")
                       return
                   } else {
                       let paramater = [
                           "emailId" : "\(email)",
                           "password" : "\(password)",
                           "facebookId" : "",
                           "googleId" : "",
                           "singuptype" : "1",
                           "first_name" : "",
                           "last_name" : "",
                           "DOB" : "",
                           "Gender" : "",
                           "group" : "",
                           "username" : ""
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
                               print(jsonRespose)
                               print(jsonRespose["message"].stringValue)
                            self.view.makeToast( "\(jsonRespose["message"].stringValue)")
                               
                               if jsonRespose["message"].stringValue == "Login Completed." {
                                
                                for i in jsonRespose["data"].arrayValue {
                                    let customerId = i["customer_id"].stringValue
                                    self.userdefault.setValue(customerId, forKey: "customer_id")
                                    print(customerId)
                                }
                                  self.navigationController?.popViewController(animated: true)
                               } else {
                                self.view.makeToast( "\(jsonRespose["message"].stringValue)")
                               }

                               self.indicator.stopAnimating()
                           }
                       }
           }
    }
    
    
}

