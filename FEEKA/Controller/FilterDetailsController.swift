//
//  FilterDetailsController.swift
//  FEEKA
//
//  Created by Apple Guru on 19/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class FilterDetailsController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var navView: UIView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FilterDetailsCell
        cell.txtLbl.tag = indexPath.row+1
        cell.img.tag = indexPath.row+1000
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let label2 = self.view.viewWithTag(indexPath.row+1) as! UILabel
        label2.text = "click"
        let image2 = self.view.viewWithTag(indexPath.row+1000) as! UIImageView
        if image2.image == UIImage(named: "3"){
            image2.image = UIImage(named: "close")
        }else {
        image2.image = UIImage(named: "3")
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navView.setShadow()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
