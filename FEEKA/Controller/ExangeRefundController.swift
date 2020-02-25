//
//  ExangeRefundController.swift
//  FEEKA
//
//  Created by Apple Guru on 25/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class ExangeRefundController: UIViewController {

    @IBOutlet weak var firstBg: UIView!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var secondBg: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navView.setShadow()
        
        firstBg?.layer.cornerRadius = 7
        firstBg?.layer.shadowColor = UIColor.black.cgColor
        firstBg?.layer.shadowOpacity = 0.3
        firstBg?.layer.shadowOffset = .zero
        firstBg?.layer.shadowRadius = 0.5
        secondBg?.layer.cornerRadius = 7
        secondBg?.layer.shadowColor = UIColor.black.cgColor
        secondBg?.layer.shadowOpacity = 0.3
        secondBg?.layer.shadowOffset = .zero
        secondBg?.layer.shadowRadius = 0.5

        // Do any additional setup after loading the view.
    }
    @IBAction func refundAction(_ sender: Any) {
        
        
    }
    

    @IBAction func returnPolicyAction(_ sender: Any) {
        if let url = URL(string: "https://feeka.co.za/delivery-return-policy/") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    @IBAction func exchangeAction(_ sender: Any) {
        
    }
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ExangeRefundController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ExangeRefundCell
        
        cell?.selectedBackgroundView = UIView()
        cell?.bgView.layer.cornerRadius = 7
        cell?.bgView.layer.shadowColor = UIColor.black.cgColor
        cell?.bgView.layer.shadowOpacity = 0.3
        cell?.bgView.layer.shadowOffset = .zero
        cell?.bgView.layer.shadowRadius = 0.5
        return cell!
     }
    
    
}
