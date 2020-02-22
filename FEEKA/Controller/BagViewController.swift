//
//  BagViewController.swift
//  FEEKA
//
//  Created by Apple Guru on 22/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class BagViewController: UIViewController, UIViewControllerTransitioningDelegate {

    let userdefault = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        guard (userdefault.value(forKey: "customer_id") as? String) != nil else {
            signOutAction()
            return
        }
    }
    
    func signOutAction() {
        let navVc = storyboard?.instantiateViewController(withIdentifier: "loginnav")
        navVc!.modalPresentationStyle = .overFullScreen
        navVc!.transitioningDelegate = self
        present(navVc!, animated: true, completion: nil)
    }

}
