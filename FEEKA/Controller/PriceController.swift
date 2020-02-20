//
//  PriceController.swift
//  FEEKA
//
//  Created by Apple Guru on 19/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import TTRangeSlider
class PriceController: UIViewController {

    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var rangeSlider: TTRangeSlider!
    var maxData = ""
    var minData = ""
    var currency = ""
    var maxSetValue = 0
    var minSetValue = 0
    let userDefault = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        rangeSlider.maxValue = Float(maxData)!
        rangeSlider.minValue = Float(minData)!
        navView.setShadow()
        
    }
    @IBAction func rangeSlider(_ sender: Any) {
        minSetValue = Int(rangeSlider.selectedMinimum)
        maxSetValue = Int(rangeSlider.selectedMaximum)
//        print(minValue)
//        print(maxValue)
    }
    
    @IBAction func cancle(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func setRange(_ sender: Any) {
        
        userDefault.setValue("\(maxSetValue)", forKey: "filterMaxValue")
        userDefault.setValue("\(minSetValue)", forKey: "filterMinValue")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
