//
//  FinderController.swift
//  FEEKA
//
//  Created by Apple Guru on 25/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class FinderController: UIViewController {

    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var quizBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        navView.setShadow()
        quizBtn.layer.cornerRadius = 10
        quizBtn.layer.borderColor = UIColor.gray.cgColor
        quizBtn.layer.borderWidth = 0.7
    }
    
    @IBAction func backBtn(_ sender: Any) {
    }
    
    @IBAction func quizBtn(_ sender: Any) {
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
