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
import FacebookCore
import FacebookLogin

class LogInViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
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
       NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
             
               NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
             hideKeyBoard()
         }
         
        @objc func keyboardWillShow(notification: Notification) {
             if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//                 if self.view.frame.origin.y == 0{
//                     self.view.frame.origin.y -= keyboardSize.height
//                 }
             }

         }

         @objc func keyboardWillHide(notification: Notification) {
             if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//                 if self.view.frame.origin.y != 0 {
//                     self.view.frame.origin.y += keyboardSize.height
//                 }
             }
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
    
    func bagApiCalling() {
           guard let urlToExcute = URL(string: "https://feeka.co.za/json-api/route/view_to_cart_v4.php") else {
               return
           }
           let userdefault = UserDefaults.standard
           var customerId = ""
        
        if userdefault.value(forKey: "customer_id") as? String != nil {
            customerId = userdefault.value(forKey: "customer_id") as! String
        } else {
            
        }
           
           let parameter = ["customer_id":"\(customerId)"]
           
           Alamofire.request(urlToExcute, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
           
           if let error = response.error {
               print(error)
               
           }
           
               if let response = response.result.value {
                   let jsonResponse = JSON(response)
                                     
                       let data = jsonResponse["data"].arrayValue
                   
                   
                   if let tabItems = self.tabBarController?.tabBar.items {
                                  
                                  let tabItem = tabItems[2]
                                  tabItem.badgeValue = "\(data.count)"
                              }
               
               }
               
           }
       }
        
    
    @IBAction func loginWithFacebook(_ sender: Any) {
        let loginManager = LoginManager()
        var email = "nill"
        var id = ""
        loginManager.logOut()
        loginManager.logIn(permissions: [ .publicProfile,.email ], viewController: self) { loginResult in
            
            switch loginResult {
                
            case .failed(let error):
                print(error)
                
            case .cancelled:
                print("User cancelled login.")
                
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
                StoredProperty.FacebookAuthsuccess = true
                print(accessToken)
                let connection = GraphRequestConnection()
                let request = GraphRequest.init(graphPath: "me")
                request.parameters = ["fields": "email, id"]
                connection.add(request, completionHandler: {
                    (response, result, error) in
                    print(response)
                    if ((error != nil)) {
                        print("Error took place: \(String(describing: error))")
                    } else {
                        let dict = result as? [String : AnyObject]
                        print(dict!)
                        if dict!["email"] == nil {
                            let alert =  ShowAlertView().alertView(title: "", action: "OK", message: "Email Not Found")
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            //print(dict!["gmail"]!)
                            email = "\(dict!["email"]!)"
                            id = "\(dict!["id"]!)"
                            
                            self.logInApi(email: email, password: "", id: id, signType: 2)
                            
                        }
                    }
                })
                connection.start()
            }

            }
        
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        tabBarController?.selectedIndex = 0
        NotificationCenter.default.post(name: Notification.Name("goHome"), object: nil)
    }
    
    func logInApi(email: String, password: String, id: String, signType: Int) {
        
        guard let url = URL(string: "https://feeka.co.za/json-api/route/Login_Registration.php") else {
         self.view.makeToast( "Please try again later")
            return
        }
        let paramater = [
                                  "emailId" : "\(email)",
                                  "password" : "\(password)",
                                  "facebookId" : "",
                                  "googleId" : "",
                                  "singuptype" : "\(signType)",
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
                     let authorName = i["Name"].stringValue
                     self.userdefault.setValue(authorName, forKey: "author_name")
                     self.userdefault.setValue(customerId, forKey: "customer_id")
                     print(customerId)
                 }
                    self.bagApiCalling()
                   self.navigationController?.popViewController(animated: true)
                   self.dismiss(animated: true, completion: nil)
                } else {
                 self.view.makeToast( "\(jsonRespose["message"].stringValue)")
                }

                self.indicator.stopAnimating()
            }
        }
        
    }
    
    @IBAction func logIn(_ sender: Any) {
        
        guard let password = passwordField.text, let email = emailField.text else {
                       self.showToast(message: "Please fill all Field")
                       return
                   }
                   
                   if  password == "" || email == "" {
                    self.view.makeToast( "Please fill all Field")
                       return
                   } else {
                      
                    logInApi(email: email, password: password, id: "", signType: 1)
           }
    }
    
    
}

