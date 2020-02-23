//
//  FilterDetailsController.swift
//  FEEKA
//
//  Created by Apple Guru on 19/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class FilterDetailsController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var filterSubName: UILabel!
    var dataList = [String]()
    var dataListTerms = [String]()
    @IBOutlet weak var navView: UIView!
    var filterCategorie = ""
    let userdefault = UserDefaults.standard
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FilterDetailsCell
        cell.img.tag = indexPath.row+3000
        cell.txtLbl.text = dataList[indexPath.row]
        cell.selectedBackgroundView = UIView()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let image2 = self.view.viewWithTag(indexPath.row+3000) as! UIImageView
        image2.image = UIImage(named: "checkbox-tick")
        userdefault.setValue(dataListTerms[indexPath.row], forKey: filterCategorie)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let image2 = self.view.viewWithTag(indexPath.row+3000) as! UIImageView
        image2.image = UIImage(named: "close")
        
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navView.setShadow()
        filterSubName.text = filterCategorie.uppercased()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
