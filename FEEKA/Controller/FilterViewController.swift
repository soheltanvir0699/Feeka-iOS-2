//
//  FilterViewController.swift
//  FEEKA
//
//  Created by Apple Guru on 19/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var listTbl: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navView.setShadow()
        
        UITableViewCell.appearance().selectedBackgroundView = UIView()
    }


    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func applyBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func clearBtn(_ sender: Any) {
        
    }
    
}
extension FilterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FilterCell
        cell.productView.layer.borderColor = UIColor.black.cgColor
        cell.productView.layer.borderWidth = 1
        cell.clipsToBounds = true
        cell.separatorInset.top  = 100
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            let priceVC = storyboard?.instantiateViewController(withIdentifier: "PriceController") as! PriceController
            navigationController?.pushViewController(priceVC, animated: true)
        } else {
            let fDetailsVC = storyboard?.instantiateViewController(withIdentifier: "fDetails") as! FilterDetailsController
                   navigationController?.pushViewController(fDetailsVC, animated: true)
        }
    }
    
    
}
