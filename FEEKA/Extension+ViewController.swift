//
//  Extension+ViewController.swift
//  FEEKA
//
//  Created by Al Mujahid Khan on 2/14/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

//
//  FacebookAuth.swift
//  FEEKA
//
//  Created by Apple Guru on 12/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import Alamofire
import SwiftyJSON
import SVProgressHUD
import NVActivityIndicatorView

extension UIViewController {
    
    func facebookAuth() {
        
        let loginManager = LoginManager()
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
                request.parameters = ["fields": "email, first_name, last_name, picture.width(1000).height(1000), birthday, gender"]
                connection.add(request, completionHandler: {
                    (response, result, error) in
                    
                    if ((error != nil)) {
                         print("Error took place: \(error)")
                    } else {
                        let dict = result as? [String : AnyObject]
                        print(dict)
                        if dict!["gmail"] == nil {
                            print("nill")
                        }
                        //self.checkUser(loginEmail: "soheltanvir0699@gmail.com")
                    }
                })
                connection.start()
            }

            }
    }
    
    func hideKeyBoard() {
       let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        self.view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
        
    }
    
   @objc func endEditing() {
        self.view.endEditing(true)
    }
}


