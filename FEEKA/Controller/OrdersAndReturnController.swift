//
//  OrdersAndReturnController.swift
//  FEEKA
//
//  Created by Apple Guru on 25/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class OrdersAndReturnController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? OrderAndReturnCell
        cell?.bgView.layer.cornerRadius = 7
        cell?.bgView.layer.shadowColor = UIColor.black.cgColor
        cell?.bgView.layer.shadowOpacity = 0.3
        cell?.bgView.layer.shadowOffset = .zero
        cell?.bgView.layer.shadowRadius = 0.5
        cell?.selectedBackgroundView = UIView()
        return cell!
    }
    
    @IBOutlet weak var navView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navView.setShadow()
    }
    
    @IBAction func backAction(_ sender: Any) {
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
