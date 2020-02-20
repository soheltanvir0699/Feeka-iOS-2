//
//  ForgotPasswordViewController.swift
//  FEEKA
//
//  Created by Apple Guru on 11/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var resetBtn: UIButton!
    var indicator: NVActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        resetBtn.layer.cornerRadius = 5
        self.navigationItem.title = "FORGOT PASSWORD"
        indicator = self.indicator()
        
    }
    


    @IBAction func resetPass(_ sender: Any) {
        guard  let email = emailField.text else {
                    self.showToast(message: "Please fill all Field")
                    return
                }
                guard let url = URL(string: "https://feeka.co.za/json-api/route/forgot_password.php") else {
                    self.showToast(message: "Please try again later")
                    return
                }
                
                if  email == "" {
                    self.showToast(message: "Please fill all Field")
                    return
                } else {
                    let paramater = [
                        "Email_address" :"\(email)"
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
                            
                            if jsonRespose["message"].stringValue == "Please check your email." {
                               let alert = ShowAlertView().alertView(title: "Please check your email.", action: "OK", message: "")
                               self.present(alert, animated: true, completion: nil)
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
