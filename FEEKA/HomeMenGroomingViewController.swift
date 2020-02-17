//
//  HomeViewController.swift
//  FEEKA
//
//  Created by Apple Guru on 12/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class HomeMenGroomingViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var equipmentImg: UIImageView!
    @IBOutlet weak var hireCareImg: UIImageView!
    @IBOutlet weak var skinCareImg: UIImageView!
    @IBOutlet weak var brands: UIImageView!
    @IBOutlet weak var justInImg: UIImageView!
    @IBOutlet weak var saleImg: UIImageView!
    @IBOutlet weak var editorsPicksImg: UIImageView!
    
    var womenText = "Women"
    var menText = "Men"
    var menClick = false
    var womanClick = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
          setUpView()
        // Do any additional setup after loading the view.
        let nav = self.navigationController?.navigationBar
        nav?.tintColor = UIColor.black
        let imageView = UIImageView(frame: CGRect(x: 70, y: 0, width: 80, height: 30))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "feekalarge")
        imageView.image = image
        navigationItem.titleView = imageView
    }
    
   func setUpView() {
    topView.layer.cornerRadius = 5
    equipmentImg.layer.cornerRadius = 5
    hireCareImg.layer.cornerRadius = 5
    skinCareImg.layer.cornerRadius = 5
    brands.layer.cornerRadius = 5
    justInImg.layer.cornerRadius = 5
    saleImg.layer.cornerRadius = 5
    editorsPicksImg.layer.cornerRadius = 5
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(grooming(tapGestureRecognizer:)))
    equipmentImg.addGestureRecognizer(tapGestureRecognizer)
    
    let tapGestureHair = UITapGestureRecognizer(target: self, action: #selector(hairCare(tapGestureRecognizer:)))
    let tapGestureSale = UITapGestureRecognizer(target: self, action: #selector(saleCare(tapGestureRecognizer:)))
    let tapGestureBrand = UITapGestureRecognizer(target: self, action: #selector(brand(tapGestureRecognizer:)))
    let tapGestureskin = UITapGestureRecognizer(target: self, action: #selector(skin(tapGestureRecognizer:)))
    let tapGestureEditor = UITapGestureRecognizer(target: self, action: #selector(editor(tapGestureRecognizer:)))
    let tapGestureJustIn = UITapGestureRecognizer(target: self, action: #selector(justIn(tapGestureRecognizer:)))
    
    hireCareImg.addGestureRecognizer(tapGestureHair)
    skinCareImg.addGestureRecognizer(tapGestureskin)
    saleImg.addGestureRecognizer(tapGestureSale)
    editorsPicksImg.addGestureRecognizer(tapGestureEditor)
    brands.addGestureRecognizer(tapGestureBrand)
    justInImg.addGestureRecognizer(tapGestureJustIn)

    }

    @IBAction func menuAction(_ sender: Any) {
        var menAction = UIAlertAction()
        
        let alert = UIAlertController(title: "Gender", message: nil, preferredStyle: .actionSheet)
        let womenAction = UIAlertAction(title: womenText, style: .default) { (women) in
            self.womanClick = true
            self.menClick = false
        }
        menAction = UIAlertAction(title: menText, style: .default) { (button) in
            self.womanClick = false
            self.menClick = true
        }
        let canAction = UIAlertAction(title: "Cancle", style: .cancel) { (_) in
            alert.removeFromParent()
        }
        alert.addAction(womenAction)
        alert.addAction(menAction)
        alert.addAction(canAction)
        alert.view.backgroundColor = .clear
        alert.view.tintColor = .black
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func grooming(tapGestureRecognizer: UITapGestureRecognizer) {
           let menGroomingVC = storyboard?.instantiateViewController(withIdentifier: "HomeProductDetailsViewController") as! HomeProductDetailsViewController
           self.navigationController?.pushViewController(menGroomingVC, animated: true)
       }
       @objc func brand(tapGestureRecognizer: UITapGestureRecognizer) {
           let menGroomingVC = storyboard?.instantiateViewController(withIdentifier: "HomeProductDetailsViewController") as! HomeProductDetailsViewController
           self.navigationController?.pushViewController(menGroomingVC, animated: true)
       }
    @objc func justIn(tapGestureRecognizer: UITapGestureRecognizer) {
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
