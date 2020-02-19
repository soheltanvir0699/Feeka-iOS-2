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
    var maxValue = 0
    var minValue = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        rangeSlider.maxValue = 500
        rangeSlider.minValue = 200
        navView.setShadow()
        
    }
    @IBAction func rangeSlider(_ sender: Any) {
        minValue = Int(rangeSlider.selectedMinimum)
        maxValue = Int(rangeSlider.selectedMaximum)
        print(minValue)
        print(maxValue)
    }
    
    @IBAction func cancle(_ sender: Any) {
    }
    
    @IBAction func setRange(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
