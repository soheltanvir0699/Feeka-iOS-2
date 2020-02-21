//
//  DiscoverSearchViewController.swift
//  FEEKA
//
//  Created by Al Mujahid Khan on 2/16/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class DiscoverSearchViewController: UIViewController,UITextFieldDelegate {
  @IBOutlet weak var searchBorder: UILabel!
  @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var navView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navView.setShadow()
        searchField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        searchBorder.backgroundColor = .gray
       }
       
       func textFieldDidBeginEditing(_ textField: UITextField) {
        searchBorder.backgroundColor = .black
        
       }
       
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        discoverVC(textfield: textField)
               return textField.resignFirstResponder()
       }
       override func viewWillAppear(_ animated: Bool) {
           //hideKeyBoard()
       }
    
    func discoverVC(textfield: UITextField) {
        let discoverVC = storyboard?.instantiateViewController(withIdentifier: "DiscoverViewController") as! DiscoverViewController
        discoverVC.searchTag = textfield.text!
        navigationController?.pushViewController(discoverVC, animated: true)
    }
 
    @IBAction func backBtn(_ sender: Any) {
        tabBarController?.selectedIndex = 0
    }
}

extension DiscoverSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.selectedBackgroundView = UIView()
        cell?.textLabel?.text = "Search Text"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    
}
