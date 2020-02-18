//
//  HomeViewController.swift
//  FEEKA
//
//  Created by Apple Guru on 12/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class HomeMenGroomingViewController: UIViewController {

    @IBOutlet weak var skinCare: UILabel!
    @IBOutlet weak var brandLbl: UILabel!
    @IBOutlet weak var hireCareLbl: UILabel!
    @IBOutlet weak var topView: UIImageView!
    @IBOutlet weak var equipmentImg: UIImageView!
    @IBOutlet weak var hireCareImg: UIImageView!
    @IBOutlet weak var skinCareImg: UIImageView!
    @IBOutlet weak var brands: UIImageView!
    @IBOutlet weak var justInImg: UIImageView!
    @IBOutlet weak var saleImg: UIImageView!
    @IBOutlet weak var editorsPicksImg: UIImageView!
    @IBOutlet weak var skinCarelbl: UILabel!
    
    @IBOutlet weak var saleLbl: UILabel!
    @IBOutlet weak var editorsPicks: UILabel!
    @IBOutlet weak var justInLbl: UILabel!
    @IBOutlet weak var equipmentLbl: UILabel!
    
    private let networkingClint = NetworkingClient()
    var womenText = "Women"
    var menText = "Men"
    var menClick = false
    var womanClick = false
    var activityIndicator:NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
          setUpView()
        let nav = self.navigationController?.navigationBar
        nav?.tintColor = UIColor.black
        let imageView = UIImageView(frame: CGRect(x: 70, y: 0, width: 80, height: 30))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "feekalarge")
        imageView.image = image
        navigationItem.titleView = imageView
        
        activityIndicator = self.indicator()
        activityIndicator.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
guard let urlToExcute = URL(string: "https://feeka.co.za/json-api/route/dashboard.php") else {
    return
}
let parameter: [String:String] = ["Gender":"1"]
Alamofire.request(urlToExcute, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
    if let error = response.error {
        self.activityIndicator.stopAnimating()
        let alertView = ShowAlertView().alertView(title: "Something went wrong", action: "OK", message: "Please try again.")
        self.present(alertView, animated: true, completion: nil)
        print(error)
    }
    if let respose = response.result.value {
        let jsonResponse = JSON(respose)
        let dataList = jsonResponse["data"].arrayValue
         for i in dataList {
            let image = i["image"].stringValue
            print(image)
            if i["id"] == "3" {
                self.skinCareImg.downloaded(from: i["image"].stringValue, contentMode: .scaleAspectFill)
                self.skinCarelbl.text = i["title"].stringValue
            }
            if i["id"] == "4" {
                let image = UIImage.gif(url: i["image"].stringValue)
                self.brands.image = image
                self.brandLbl.text = i["title"].stringValue
            }
            if i["id"] == "13" {
                self.justInImg.downloaded(from: i["image"].stringValue, contentMode: .scaleAspectFill)
                self.justInLbl.text = i["title"].stringValue
            }
            if i["id"] == "12" {
                let image = UIImage.gif(url: i["image"].stringValue)
                self.saleImg.image = image
                self.saleLbl.text = i["title"].stringValue
            }
            if i["id"] == "14" {
                self.editorsPicksImg.downloaded(from: i["image"].stringValue, contentMode: .scaleAspectFill)
                self.editorsPicks.text = i["title"].stringValue
            }
            if i["id"] == "22" {
                self.topView.downloaded(from: i["image"].stringValue, contentMode: .scaleAspectFill)
            }
            
            if i["id"] == "1" {
                self.hireCareImg.downloaded(from: i["image"].stringValue, contentMode: .scaleAspectFill)
                self.hireCareLbl.text = i["title"].stringValue
            }
            if i["id"] == "2" {
                self.equipmentImg.downloaded(from: i["image"].stringValue, contentMode: .scaleAspectFill)
                self.equipmentLbl.text = i["title"].stringValue
            }
        }
        self.activityIndicator.stopAnimating()
    }
}
        
        
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
