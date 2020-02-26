//
//  PaymentViewController.swift
//  FEEKA
//
//  Created by Apple Guru on 25/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class PaymentViewController: UIViewController {

    @IBOutlet weak var payFastImg: UIImageView!
    @IBOutlet weak var ozowImg: UIImageView!
    @IBOutlet weak var fontView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var promoField: UITextField!
    @IBOutlet weak var promoView: UIView!
    @IBOutlet weak var navView: UIView!
    
    var indicator:NVActivityIndicatorView!
    var userdefault = UserDefaults.standard
    var customerId = ""
    var payment = 2
    override func viewDidLoad() {
        super.viewDidLoad()

        backView.layer.cornerRadius = 5
        fontView.layer.cornerRadius = 3
        promoView.layer.cornerRadius = 5
        promoView.layer.shadowColor = UIColor.gray.cgColor
        promoView.layer.shadowOpacity = 0.7
        promoView.layer.shadowOffset = .zero
        promoView.layer.shadowRadius = 1
        navView.setShadow()
        payFastImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(payAction)))
        ozowImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ozowAction)))
        
            hideKeyBoard()
        if  userdefault.value(forKey: "customer_id") as! String != "" {
            customerId = userdefault.value(forKey: "customer_id") as! String
        }
        
        if userdefault.value(forKey: "customer_id") as? String != nil {
            customerId = userdefault.value(forKey: "customer_id") as! String
        }
    }
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
     
    
    
    @objc func payAction() {
         payFastImg.image = UIImage(named: "radio-active")
        ozowImg.image = UIImage(named: "radio-inactive")
        self.payment = 2
    }
    
    @objc func ozowAction() {
        ozowImg.image = UIImage(named: "radio-active")
        payFastImg.image = UIImage(named: "radio-inactive")
        self.payment = 3
    }

    @IBAction func applayAction(_ sender: Any) {
        
        couponApi()
    }
    @IBAction func continueAction(_ sender: Any) {
        
        let ConfirmOrderVC = storyboard?.instantiateViewController(identifier: "ConfirmOrderViewController") as? ConfirmOrderViewController
        ConfirmOrderVC?.method = payment
        ConfirmOrderVC?.modalPresentationStyle = .fullScreen
        
        present(ConfirmOrderVC!, animated: true, completion: nil)
    }
    
    func couponApi() {
        
    indicator = self.indicator()
           indicator.startAnimating()
           guard let urlToExcute = URL(string: "https://feeka.co.za/json-api/route/coupon_validate.php") else {
               return
           }
        var parameter = [String:String]()
        if promoField.text != nil {
           
       parameter  = ["coupon_code":"\(promoField.text!)","customer_id":"\(self.customerId)"]
        }
           
           
           Alamofire.request(urlToExcute, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
           
           if let error = response.error {
               self.indicator.stopAnimating()
               let alertView = ShowAlertView().alertView(title: "Something went wrong", action: "OK", message: "Please try again.")
               self.present(alertView, animated: true, completion: nil)
               print(error)
               
           }
           
               if let response = response.result.value {
                   let jsonResponse = JSON(response)
                                     
                let alert = ShowAlertView().alertView(title: "", action: "Ok", message: (jsonResponse["message"].stringValue))
                self.present(alert, animated: true, completion: nil)
                       self.indicator.stopAnimating()
                   
               
           }
       }
    
    
    }
    
}
