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
    var arrayList = [String]()
      let userdefault = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        navView.setShadow()
        searchField.becomeFirstResponder()
        arrayList = userdefault.value(forKey: "arrayList") as! [String]
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
        tableView.reloadData()
       }
    
    func discoverVC(textfield: UITextField) {
        let discoverVC = storyboard?.instantiateViewController(withIdentifier: "DiscoverViewController") as! DiscoverViewController
        discoverVC.searchTag = textfield.text!
        arrayList.append(textfield.text!)
        userdefault.setValue(arrayList, forKey: "arrayList")
        navigationController?.pushViewController(discoverVC, animated: true)
    }
 
    @IBAction func backBtn(_ sender: Any) {
        tabBarController?.selectedIndex = 0
    }
    @IBAction func clearSearchList(_ sender: Any) {
        arrayList = [String]()
        userdefault.setValue(arrayList, forKey: "arrayList")
        tableView.reloadData()
    }
}

extension DiscoverSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.selectedBackgroundView = UIView()
        cell?.textLabel?.text = arrayList[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    
}
