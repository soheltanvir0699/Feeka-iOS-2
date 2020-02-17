//
//  MoreViewController.swift
//  FEEKA
//
//  Created by Apple Guru on 13/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

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
  
    override func viewDidLoad() {
        super.viewDidLoad()
         setUpView()
    }
    
   
    
    @IBAction func settingAction(_ sender: Any) {
        
        let navVc = storyboard?.instantiateViewController(withIdentifier: "loginnav")
        navVc!.modalPresentationStyle = .overCurrentContext
        navVc!.transitioningDelegate = self
        present(navVc!, animated: true, completion: nil)
        
    }
    
    func setUpView() {
        termsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(termsAction)))
        policyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(policyAction)))
        faqsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fapsAction)))
        privacyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(privacyAction)))
        contactView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(contactAction)))
        aboutView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(aboutAction)))
        signOutView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signOutAction)))
        changePassView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signOutAction)))
        newsletterView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(newslettersAction)))
        orderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signOutAction)))
        deliveryView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deliveryAction)))
        wishListView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(wishlistAction)))
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
        navVc!.modalPresentationStyle = .overCurrentContext
        navVc!.transitioningDelegate = self
        present(navVc!, animated: true, completion: nil)
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
}


extension MoreViewController: UIViewControllerTransitioningDelegate {
    
}
