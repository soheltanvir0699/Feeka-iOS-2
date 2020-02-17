//
//  ForgotPasswordViewController.swift
//  FEEKA
//
//  Created by Apple Guru on 11/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var resetBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        resetBtn.layer.cornerRadius = 5
        self.navigationItem.title = "FORGOT PASSWORD"
        
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
