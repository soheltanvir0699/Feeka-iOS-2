//
//  Extension+ViewController.swift
//  FEEKA
//
//  Created by Al Mujahid Khan on 2/14/20.
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
                        print("Error took place: \(String(describing: error))")
                    } else {
                        let dict = result as? [String : AnyObject]
                        print(dict!)
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
    
    func showToast(message : String) {
           let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 100, y: self.view.frame.size.height-150, width: 200, height: 35))
           toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
           toastLabel.textColor = UIColor.white
           toastLabel.textAlignment = .center;
           toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
           toastLabel.text = message
           toastLabel.alpha = 1.0
        toastLabel.sizeToFit()
           toastLabel.layer.cornerRadius = 10;
           toastLabel.clipsToBounds  =  true
           self.view.addSubview(toastLabel)
          
           UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
               toastLabel.alpha = 0.0
           }, completion: {(isCompleted) in
               toastLabel.removeFromSuperview()
           })

    }
    
     func indicator() -> NVActivityIndicatorView {
        let activityIndicator: NVActivityIndicatorView!
        let xAxis = self.view.center.x
        let yAxis = self.view.center.y
        
        let frame = CGRect(x: (xAxis - 27), y: (yAxis - 50), width: 55, height: 55)
        activityIndicator = NVActivityIndicatorView(frame: frame)
        activityIndicator.type = .ballClipRotate
        activityIndicator.color = UIColor.black
        
        self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
        return activityIndicator
    }
}




