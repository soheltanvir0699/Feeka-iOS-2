//
//  ViewController.swift
//  FEEKA
//
//  Created by Apple Guru on 11/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var hideShowBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var singUpStringLabel: UILabel!
    var ishidePassword = false
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
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
    
}

