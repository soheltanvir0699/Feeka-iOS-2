//
//  BagViewController.swift
//  FEEKA
//
//  Created by Apple Guru on 22/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class BagViewController: UIViewController, UIViewControllerTransitioningDelegate {
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var topView: UIView!
    
    let userdefault = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.setShadow()
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
    
    
    @IBAction func checkOutAction(_ sender: Any) {
        let deliveryVC = storyboard?.instantiateViewController(withIdentifier: "DeliveryViewController") as! DeliveryViewController
        deliveryVC.modalPresentationStyle = .fullScreen
        
        self.present(deliveryVC, animated: true, completion: nil)
    }
    
}

extension BagViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 9 {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2")
            cell2?.selectedBackgroundView = UIView()
            cell2?.contentView.setShadow()
            return cell2!
        } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            cell?.selectedBackgroundView = UIView()
        
            return cell!
            
        }
    }
    
    
}
