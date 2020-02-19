//
//  NewslettersViewController.swift
//  FEEKA
//
//  Created by Al Mujahid Khan on 2/16/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class NewslettersViewController: UIViewController {

    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var womenBtn: UIButton!
    @IBOutlet weak var menBtn: UIButton!
    
    var isAll = true
    var isMen = true
    var isWomen = true
    var genderKey = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func allCheckBoxAction(_ sender: Any) {
       if isAll {
            
            allBtn.setImage(#imageLiteral(resourceName: "3"), for: .normal)
            menBtn.setImage(#imageLiteral(resourceName: "3"), for: .normal)
            womenBtn.setImage(#imageLiteral(resourceName: "3"), for: .normal)
            isAll = false
            isMen = false
            isWomen = false
            
        } else {
            
            isAll = true
            isMen = true
            isWomen = true
            allBtn.setImage(nil, for: .normal)
            menBtn.setImage(nil, for: .normal)
            womenBtn.setImage(nil, for: .normal)
        }
    }
    
    @IBAction func womenCheckBoxAction(_ sender: Any) {
        if isWomen {
            
        womenBtn.setImage(#imageLiteral(resourceName: "3"), for: .normal)
            isWomen = false
            
        } else {
            
            isWomen = true
            womenBtn.setImage(nil, for: .normal)
        }
        
        //dfdf
    }
    
    @IBAction func menCheckBoxAction(_ sender: Any) {
        if isMen {
        menBtn.setImage(#imageLiteral(resourceName: "3"), for: .normal)
            isMen = false
        } else {
            isMen = true
            menBtn.setImage(nil, for: .normal)
        }
    }
    @IBAction func updateBtn(_ sender: Any) {
        if !isAll {
            
        }  else if !isMen {
            genderKey = 2
            let userDefault = UserDefaults.standard
                   userDefault.setValue(genderKey, forKey: "Gender")
                   let read = userDefault.value(forKey: "Gender")
                   print(read as? Int)
        } else if !isWomen {
            genderKey = 1
            let userDefault = UserDefaults.standard
                   userDefault.setValue(genderKey, forKey: "Gender")
                   let read = userDefault.value(forKey: "Gender")
            print(read as! Int)
        }
       
    }

}
