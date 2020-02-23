//
//  DeliveryViewController.swift
//  FEEKA
//
//  Created by Apple Guru on 23/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class DeliveryViewController: UIViewController {

    @IBOutlet weak var addressView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addressView.setShadow()
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
