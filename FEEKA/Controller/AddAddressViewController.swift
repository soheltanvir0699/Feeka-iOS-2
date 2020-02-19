//
//  AddAddressViewController.swift
//  FEEKA
//
//  Created by Al Mujahid Khan on 2/16/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class AddAddressViewController: UIViewController {

    @IBOutlet weak var navView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        alertView()
        navView.setShadow()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addAddressBtn(_ sender: Any) {
        let addressDetails = storyboard?.instantiateViewController(withIdentifier: "AddAddressDetailsViewController") as? AddAddressDetailsViewController
        self.navigationController?.pushViewController(addressDetails!, animated: true)
    }
  
    fileprivate func alertView() {
        let alertVc = ShowAlertView().alertView(title: "Please add new address", action: "OK", message: "")
           self.present(alertVc, animated: true, completion: nil)
         }
         

}
