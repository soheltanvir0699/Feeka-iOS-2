//
//  ConfirmOrderViewController.swift
//  FEEKA
//
//  Created by Apple Guru on 25/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class ConfirmOrderViewController: UIViewController {

    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navView.setShadow()
        
    }
    

}

extension ConfirmOrderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1  = tableView.dequeueReusableCell(withIdentifier: "cell1") as? ConfirmFirstCell
        cell1?.bgFirstView.layer.cornerRadius = 4
        cell1?.bgFirstView.layer.shadowColor = UIColor.black.cgColor
        cell1?.bgFirstView.layer.shadowOpacity = 0.3
        cell1?.bgFirstView.layer.shadowOffset = .zero
        cell1?.bgFirstView.layer.shadowRadius = 0.5
        cell1?.bgView.layer.cornerRadius = 7
        cell1?.bgView.layer.shadowColor = UIColor.black.cgColor
        cell1?.bgView.layer.shadowOpacity = 0.3
        cell1?.bgView.layer.shadowOffset = .zero
        cell1?.bgView.layer.shadowRadius = 0.5
        cell1?.selectedBackgroundView = UIView()
        
        
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2") as? ConfrimSecondCell
        
        cell2?.selectedBackgroundView = UIView()
        cell2?.bgView.layer.cornerRadius = 7
        cell2?.bgView.layer.shadowColor = UIColor.black.cgColor
        cell2?.bgView.layer.shadowOpacity = 0.3
        cell2?.bgView.layer.shadowOffset = .zero
        cell2?.bgView.layer.shadowRadius = 0.5
        cell2?.bgView2.layer.cornerRadius = 7
        cell2?.bgView2.layer.shadowColor = UIColor.black.cgColor
        cell2?.bgView2.layer.shadowOpacity = 0.3
        cell2?.bgView2.layer.shadowOffset = .zero
        cell2?.bgView2.layer.shadowRadius = 0.5
        
        if indexPath.row == 8 {
            cell2?.bgView2.isHidden = true
            return cell2!
        } else if indexPath.row == 9 {
            cell2?.bgView2.isHidden = false
            return cell2!
            
        } else {
            return cell1!
        }
        
    }
    
    
}
