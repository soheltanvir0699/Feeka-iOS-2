//
//  MoreViewController.swift
//  FEEKA
//
//  Created by Apple Guru on 13/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MoreViewController: UIViewController {

    @IBOutlet weak var termsView: UIView!
    @IBOutlet weak var privacyView: UIView!
    @IBOutlet weak var faqsView: UIView!
    @IBOutlet weak var policyView: UIView!
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var signOutView: UIView!
    @IBOutlet weak var changePassView: UIView!
    @IBOutlet weak var pushView: UIView!
    @IBOutlet weak var newsletterView: UIView!
    @IBOutlet weak var orderView: UIView!
    @IBOutlet weak var wishListView: UIView!
    @IBOutlet weak var deliveryView: UIView!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var swithBtn: UISwitch!
    
    var userdefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
         setUpView()
        navView.setShadow()
//        guard (userdefault.value(forKey: "customer_id") as? String) != nil else {
//            signOutAction()
//            return
//        }
       
        NotificationCenter.default.addObserver(self, selector: #selector(goHome), name: Notification.Name("goHome"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if userdefault.value(forKey: "customer_id") as? String == "" {
                   signOutAction()
               }
        if userdefault.value(forKey: "customer_id") as? String == nil {
            signOutAction()
        }
        
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.bagApiCalling()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.bagApiCalling()
    }
    
    @objc func goHome() {
        tabBarController?.selectedIndex = 0
    }
    
   
    
    @IBAction func settingAction(_ sender: Any) {
        
        let navVc = storyboard?.instantiateViewController(withIdentifier: "SignUpEditController") as? SignUpEditController
       // navVc!.modalPresentationStyle = .overFullScreen
        navVc!.transitioningDelegate = self
      //  present(navVc!, animated: true, completion: nil)
        self.navigationController?.pushViewController(navVc!, animated: true)
        
    }
    
    func setUpView() {
            swithBtn.isOn = false
        termsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(termsAction)))
        policyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(policyAction)))
        faqsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fapsAction)))
        privacyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(privacyAction)))
        contactView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(contactAction)))
        aboutView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(aboutAction)))
        signOutView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signOutAction)))
        changePassView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signOutAction)))
        newsletterView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(newslettersAction)))
        orderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(orderAction)))
        deliveryView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deliveryAction)))
        wishListView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(wishlistAction)))
    }
    
    func bagApiCalling() {
           guard let urlToExcute = URL(string: "https://feeka.co.za/json-api/route/view_to_cart_v4.php") else {
               return
           }
           let userdefault = UserDefaults.standard
           var customerId = ""
        
    //    if  userdefault.value(forKey: "customer_id") as! String != "" {
    //        customerId = userdefault.value(forKey: "customer_id") as! String
    //    }
        
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
    
    @objc func orderAction() {
        let ordersAndReturnVC = storyboard?.instantiateViewController(withIdentifier: "OrdersAndReturnController")
        ordersAndReturnVC?.modalPresentationStyle = .fullScreen
        present(ordersAndReturnVC!, animated: true, completion: nil)
    }
    
    @objc func deliveryAction() {
        let newslettersVC = storyboard?.instantiateViewController(withIdentifier: "AddAddressViewController") as? AddAddressViewController
        self.navigationController?.pushViewController(newslettersVC!, animated: true)
    }
    @objc func wishlistAction() {
        let wishlistVC = storyboard?.instantiateViewController(withIdentifier: "WishListViewController") as? WishListViewController
        self.navigationController?.pushViewController(wishlistVC!, animated: true)
    }
    @objc func newslettersAction() {
        let newslettersVC = storyboard?.instantiateViewController(withIdentifier: "NewslettersViewController") as? NewslettersViewController
        self.navigationController?.pushViewController(newslettersVC!, animated: true)
    }
    @objc func signOutAction() {
        let navVc = storyboard?.instantiateViewController(withIdentifier: "loginnav")
        navVc!.modalPresentationStyle = .overFullScreen
        navVc!.transitioningDelegate = self
        
        userdefault.setValue("", forKey: "customer_id")
        self.bagApiCalling()
        present(navVc!, animated: true, completion: nil)
        //navigationController?.pushViewController(navVc!, animated: true)
    }
    @objc func termsAction() {
        if let url = URL(string: "https://feeka.co.za/t-and-c/") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    @objc func policyAction() {
           if let url = URL(string: "https://feeka.co.za/delivery-return-policy/") {
               if UIApplication.shared.canOpenURL(url) {
                   UIApplication.shared.open(url, options: [:])
               }
           }
       }
    @objc func fapsAction() {
           if let url = URL(string: "https://feeka.co.za/faq/") {
               if UIApplication.shared.canOpenURL(url) {
                   UIApplication.shared.open(url, options: [:])
               }
           }
       }
    @objc func privacyAction() {
           if let url = URL(string: "https://feeka.co.za/privacy-policy/") {
               if UIApplication.shared.canOpenURL(url) {
                   UIApplication.shared.open(url, options: [:])
               }
           }
       }
    @objc func contactAction() {
           if let url = URL(string: "https://feeka.co.za/contact-us/") {
               if UIApplication.shared.canOpenURL(url) {
                   UIApplication.shared.open(url, options: [:])
               }
           }
       }
    
    @objc func aboutAction() {
              if let url = URL(string: "https://feeka.co.za/about-us/") {
                  if UIApplication.shared.canOpenURL(url) {
                      UIApplication.shared.open(url, options: [:])
                  }
              }
          }
    
    @IBAction func notificationChange(_ sender: Any) {
        guard (userdefault.value(forKey: "customer_id") as? String) != nil else {
            self.view.makeToast("Please LogIN")
            return
        }
        if swithBtn.isOn {
            notificationApi(customerId: (userdefault.value(forKey: "customer_id") as! String), status: "1")
            print("switch is on")
        } else {
            notificationApi(customerId: userdefault.value(forKey: "customer_id") as! String, status: "2")
            print("switch is off")
        }
    }
    
    func notificationApi(customerId: String, status: String) {
        guard let url = URL(string: "https://feeka.co.za/json-api/route/update_notification.php") else {
            self.view.makeToast("Please try again later")
                        return
                    }
                    
                        let paramater = [
                            "customer_id":"\(customerId)",
                            "status":"\(status)"
                        ]
                        Alamofire.request(url, method: .post, parameters: paramater, encoding: JSONEncoding.default, headers: nil).response { (response) in
                            
                            if let error = response.error {
                                self.view.makeToast("Something wrong")
                                print(error)
                                
                            }
                            
                            if let result = response.data {
                                print(result)
                                let jsonRespose = JSON(result)
                                
                                if jsonRespose.isEmpty == true {
                                    self.view.makeToast("Something Wrong")
                                }
                                if jsonRespose["message"].stringValue == "Notification prefrence updated." {
                                    if status == "1" {
                                        self.view.makeToast("Notification Turned On")
                                    } else if status == "2" {
                                        self.view.makeToast("Notification Turned Off")

                                    }
                                    
                                }

                            }
                        
            }
        
    }

    
}



extension MoreViewController: UIViewControllerTransitioningDelegate {
    
    
    
}
