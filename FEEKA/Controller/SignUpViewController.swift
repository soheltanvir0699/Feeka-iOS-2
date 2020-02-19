//
//  SignUpViewController.swift
//  FEEKA
//
//  Created by Apple Guru on 11/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var createSecureBtn: UIButton!
    @IBOutlet weak var confirmSecureBtn: UIButton!
    @IBOutlet weak var confirmPassField: UITextField!
    @IBOutlet weak var createPassField: UITextField!
    @IBOutlet weak var termsCheckBox: UIButton!
    @IBOutlet weak var menBtn: UIButton!
    @IBOutlet weak var womenBtn: UIButton!
    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var FacebookBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var DateField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    
    var isAll = true
    var isMen = true
    var isWomen = true
    var isterms = true
    var ishideCreatePassword = false
    var ishideConfirmPassword = false
    var datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        setUpView()
    }
    
    func setUpView() {
        
        self.navigationItem.title = "SIGN UP"
        FacebookBtn.layer.cornerRadius = 5
        signUpBtn.layer.cornerRadius = 5
        allBtn.setImage(nil, for: .normal)
        menBtn.setImage(nil, for: .normal)
        womenBtn.setImage(nil, for: .normal)
        termsCheckBox.setImage(nil, for: .normal)
        DateField.delegate = self
        
        creatDatePicker()
    }

    @IBAction func allCheckBoxAction(_ sender: Any) {
       if isAll {
            
            allBtn.setImage(#imageLiteral(resourceName: "3"), for: .normal)
            menBtn.setImage(#imageLiteral(resourceName: "3"), for: .normal)
            womenBtn.setImage(#imageLiteral(resourceName: "3"), for: .normal)
            isAll = false
            isMen = false
            isWomen = false
            
        } else {
            
            isAll = true
            isMen = true
            isWomen = true
            allBtn.setImage(nil, for: .normal)
            menBtn.setImage(nil, for: .normal)
            womenBtn.setImage(nil, for: .normal)
        }
    }
    
    @IBAction func womenCheckBoxAction(_ sender: Any) {
        if isWomen {
            
        womenBtn.setImage(#imageLiteral(resourceName: "3"), for: .normal)
            isWomen = false
            
        } else {
            
            isWomen = true
            womenBtn.setImage(nil, for: .normal)
        }
    }
    
    @IBAction func menCheckBoxAction(_ sender: Any) {
        if isMen {
        menBtn.setImage(#imageLiteral(resourceName: "3"), for: .normal)
            isMen = false
        } else {
            isMen = true
            menBtn.setImage(nil, for: .normal)
        }
    }
    
    @IBAction func termsAction(_ sender: Any) {
        if isterms {
                   termsCheckBox.setImage(#imageLiteral(resourceName: "3"), for: .normal)
                   isterms = false
               } else {
                   isterms = true
                   termsCheckBox.setImage(nil, for: .normal)
               }
    }
    
    @IBAction func createPassSecureAction(_ sender: Any) {
        if ishideCreatePassword {
            
            createSecureBtn.setImage(#imageLiteral(resourceName: "not-visible-interface-symbol-of-an-eye-with-a-slash-on-it"), for: .normal)
            createPassField.isSecureTextEntry = true
            ishideCreatePassword = false
            
        } else {
            
            createPassField.isSecureTextEntry = false
            ishideCreatePassword = true
            createSecureBtn.setImage(#imageLiteral(resourceName: "eye"), for: .normal)
        }
    }
    
    @IBAction func confirmPassSecureAction(_ sender: Any) {
        if ishideConfirmPassword {
            
        confirmSecureBtn.setImage(#imageLiteral(resourceName: "not-visible-interface-symbol-of-an-eye-with-a-slash-on-it"), for: .normal)
            confirmPassField.isSecureTextEntry = true
            ishideConfirmPassword = false
            
        } else {
            
            confirmPassField.isSecureTextEntry = false
            ishideConfirmPassword = true
            confirmSecureBtn.setImage(#imageLiteral(resourceName: "eye"), for: .normal)
        }
    }
    
    @IBAction func termsLinkAction(_ sender: Any) {
      
        if let url = URL(string: "https://feeka.co.za/t-and-c/") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 10 {
            textField.inputView = UIView()
            var womenText = "👩🏿‍⚖️Women"
            var menText = "🤵🏿Men"
            if textField.text == "Women" {
                womenText = "👩🏿‍⚖️ Women"
            } else {
                womenText = "Women"
            }
            
            if textField.text == "Men" {
                menText = "🤵🏿 Men"
            } else {
                menText = "Men"
            }
            
            let alert = UIAlertController(title: "Gender", message: nil, preferredStyle: .actionSheet)
            let womenAction = UIAlertAction(title: womenText, style: .default) { (women) in
                textField.text =  "Women"
                self.hideKeyboard()
            
            }
            let menAction = UIAlertAction(title: menText, style: .default) { (_) in
                textField.text = "Men"
                self.hideKeyboard()
            }
            let canAction = UIAlertAction(title: "Cancle", style: .cancel) { (_) in
                alert.removeFromParent()
                self.hideKeyboard()
            }
            alert.addAction(womenAction)
            alert.addAction(menAction)
            alert.addAction(canAction)
            alert.view.backgroundColor = .clear
            alert.view.tintColor = .black
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.endEditing(true)
    }
    
    func creatDatePicker() {
        
        datePicker.backgroundColor = .gray
        datePicker.tintColor       = .white
        datePicker.datePickerMode  = .date
        DateField.inputView    = datePicker
        
        let toolbar             = UIToolbar()
        toolbar.sizeToFit()
        toolbar.backgroundColor = .darkGray
        toolbar.tintColor       = .black
        
        let donebutton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneClicked))
        toolbar.setItems([donebutton], animated: true)
        DateField.inputAccessoryView = toolbar
        
    }
    
    @objc func doneClicked() {
        let dateFormatter        = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        DateField.text       = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func SignUpWithFacebook(_ sender: Any) {
        self.facebookAuth()
        let success = StoredProperty.FacebookAuthsuccess
        if success == true {
            navigationController?.popViewController(animated: true)
        }else {
           print("SignUp isn't successful")
        }

    }
    
    
}