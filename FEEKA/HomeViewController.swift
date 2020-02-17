//
//  HomeViewController.swift
//  FEEKA
//
//  Created by Al Mujahid Khan on 2/16/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var menGroomingImg: UIImageView!
    @IBOutlet weak var hairCareImg: UIImageView!
    @IBOutlet weak var makeUpImg: UIImageView!
    @IBOutlet weak var skincareImg: UIImageView!
    @IBOutlet weak var editorsPicks: UIImageView!
    @IBOutlet weak var saleImg: UIImageView!
    fileprivate func setUpView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(grooming(tapGestureRecognizer:)))
        menGroomingImg.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureHair = UITapGestureRecognizer(target: self, action: #selector(hairCare(tapGestureRecognizer:)))
        let tapGestureSale = UITapGestureRecognizer(target: self, action: #selector(saleCare(tapGestureRecognizer:)))
        let tapGestureMakeUp = UITapGestureRecognizer(target: self, action: #selector(makeUP(tapGestureRecognizer:)))
        let tapGestureskin = UITapGestureRecognizer(target: self, action: #selector(skin(tapGestureRecognizer:)))
        let tapGestureEditor = UITapGestureRecognizer(target: self, action: #selector(editor(tapGestureRecognizer:)))
        
        
        makeUpImg.addGestureRecognizer(tapGestureMakeUp)
        skincareImg.addGestureRecognizer(tapGestureskin)
        hairCareImg.addGestureRecognizer(tapGestureHair)
        editorsPicks.addGestureRecognizer(tapGestureEditor)
        menGroomingImg.addGestureRecognizer(tapGestureRecognizer)
        
        saleImg.addGestureRecognizer(tapGestureSale)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
    }
    
    @objc func grooming(tapGestureRecognizer: UITapGestureRecognizer) {
        let menGroomingVC = storyboard?.instantiateViewController(withIdentifier: "HomeMenGroomingViewController") as! HomeMenGroomingViewController
        self.navigationController?.pushViewController(menGroomingVC, animated: true)
    }
    @objc func makeUP(tapGestureRecognizer: UITapGestureRecognizer) {
        let menGroomingVC = storyboard?.instantiateViewController(withIdentifier: "HomeProductDetailsViewController") as! HomeProductDetailsViewController
        self.navigationController?.pushViewController(menGroomingVC, animated: true)
    }
    @objc func editor(tapGestureRecognizer: UITapGestureRecognizer) {
        let menGroomingVC = storyboard?.instantiateViewController(withIdentifier: "HomeProductDetailsViewController") as! HomeProductDetailsViewController
        self.navigationController?.pushViewController(menGroomingVC, animated: true)
    }
    @objc func skin(tapGestureRecognizer: UITapGestureRecognizer) {
           let menGroomingVC = storyboard?.instantiateViewController(withIdentifier: "HomeProductDetailsViewController") as! HomeProductDetailsViewController
           self.navigationController?.pushViewController(menGroomingVC, animated: true)
       }
    @objc func hairCare(tapGestureRecognizer: UITapGestureRecognizer) {
        let menGroomingVC = storyboard?.instantiateViewController(withIdentifier: "HomeProductDetailsViewController") as! HomeProductDetailsViewController
        self.navigationController?.pushViewController(menGroomingVC, animated: true)
    }
    @objc func saleCare(tapGestureRecognizer: UITapGestureRecognizer) {
        let menGroomingVC = storyboard?.instantiateViewController(withIdentifier: "HomeProductDetailsViewController") as! HomeProductDetailsViewController
        self.navigationController?.pushViewController(menGroomingVC, animated: true)
    }

}
