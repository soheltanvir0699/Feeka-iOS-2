//
//  HomeViewController.swift
//  FEEKA
//
//  Created by Al Mujahid Khan on 2/16/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ImageIO
import NVActivityIndicatorView
import Nuke

class HomeViewController: UIViewController {

    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var hireCareLbl: UILabel!
    @IBOutlet weak var productFinder: UIImageView!
    @IBOutlet weak var brands: UIImageView!
    @IBOutlet weak var bannerImg: UIImageView!
    @IBOutlet weak var coomingSoon: UIImageView!
    @IBOutlet weak var menGroomingImg: UIImageView!
    @IBOutlet weak var hairCareImg: UIImageView!
    @IBOutlet weak var makeUpImg: UIImageView!
    @IBOutlet weak var skincareImg: UIImageView!
    @IBOutlet weak var editorsPicks: UIImageView!
    @IBOutlet weak var saleImg: UIImageView!
    @IBOutlet weak var skinCareLbl: UILabel!
    
    @IBOutlet weak var saleLbl: UILabel!
    @IBOutlet weak var editorPickLbl: UILabel!
    @IBOutlet weak var menGroomingLbl: UILabel!
    @IBOutlet weak var makeUpLbl: UILabel!
    @IBOutlet weak var brandLbl: UILabel!
    var activityIndicator:NVActivityIndicatorView!
    
    fileprivate func setUpView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(grooming(tapGestureRecognizer:)))
        menGroomingImg.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureHair = UITapGestureRecognizer(target: self, action: #selector(hairCare(tapGestureRecognizer:)))
        let tapGestureCooming = UITapGestureRecognizer(target: self, action: #selector(cooming(tapGestureRecognizer:)))
        let tapGestureSale = UITapGestureRecognizer(target: self, action: #selector(saleCare(tapGestureRecognizer:)))
        let tapGestureMakeUp = UITapGestureRecognizer(target: self, action: #selector(makeUP(tapGestureRecognizer:)))
        let tapGestureskin = UITapGestureRecognizer(target: self, action: #selector(skin(tapGestureRecognizer:)))
        let tapGestureEditor = UITapGestureRecognizer(target: self, action: #selector(editor(tapGestureRecognizer:)))
        let tapGestureBrands = UITapGestureRecognizer(target: self, action: #selector(brand(tapGestureRecognizer:)))
        
        
        makeUpImg.addGestureRecognizer(tapGestureMakeUp)
        coomingSoon.addGestureRecognizer(tapGestureCooming)
        skincareImg.addGestureRecognizer(tapGestureskin)
        hairCareImg.addGestureRecognizer(tapGestureHair)
        editorsPicks.addGestureRecognizer(tapGestureEditor)
        menGroomingImg.addGestureRecognizer(tapGestureRecognizer)
        brands.addGestureRecognizer(tapGestureBrands)
        saleImg.addGestureRecognizer(tapGestureSale)
        brands.isUserInteractionEnabled = true
        productFinder.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(quizzez)))
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navView.setShadow()
        
        activityIndicator = self.indicator()
            
        self.homeRequest()
        
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        StoredProperty.retake = false
    }
    
    
     func homeRequest() {
        activityIndicator.startAnimating()
        guard let urlToExcute = URL(string: "https://feeka.co.za/json-api/route/dashboard.php") else {
            return
        }
        let parameter: [String:String] = ["Gender":"2"]
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
                    if i["id"] == "31" {
                        //self.coomingSoon.downloaded(from: i["image"].stringValue, contentMode: .scaleAspectFill)
                        let request = ImageRequest(
                            url: URL(string: i["image"].stringValue)!
                        )
                        Nuke.loadImage(with: request, into: self.coomingSoon)
                    }
                    if i["title"] == "Brands" {
                        let image = UIImage.gif(url: i["image"].stringValue)
                        self.brands.image = image
                        self.brandLbl.text = i["title"].stringValue
                    }
                    if i["id"] == "32" {
                       // self.productFinder.downloaded(from: i["image"].stringValue, contentMode: .scaleAspectFill)
                        let request = ImageRequest(
                            url: URL(string: i["image"].stringValue)!
                        )
                        Nuke.loadImage(with: request, into: self.productFinder)
                    }
                    if i["title"] == "sale" {
                        let image = UIImage.gif(url: i["image"].stringValue)
                        self.saleImg.image = image
                        self.saleLbl.text = i["title"].stringValue
                    }
                    if i["title"] == "Men's Grooming" {
                        //let image = UIImage.gif(url: i["image"].stringValue)
                        //self.menGroomingImg.downloaded(from: i["image"].stringValue, contentMode: .scaleAspectFill)
                        let request = ImageRequest(
                            url: URL(string: i["image"].stringValue)!
                        )
                        Nuke.loadImage(with: request, into: self.menGroomingImg)
                        self.menGroomingLbl.text = i["title"].stringValue
                    }
                    if i["title"] == "Chocolate sqeeze title" {
                       // self.bannerImg.downloaded(from: i["image"].stringValue, contentMode: .scaleAspectFill)
                        let request = ImageRequest(
                            url: URL(string: i["image"].stringValue)!
                        )
                        Nuke.loadImage(with: request, into: self.bannerImg)
                    }
                    
                    if i["title"] == "Hair Care" {
                       // self.hairCareImg.downloaded(from: i["image"].stringValue, contentMode: .scaleAspectFill)
                        let request = ImageRequest(
                            url: URL(string: i["image"].stringValue)!
                        )
                        Nuke.loadImage(with: request, into: self.hairCareImg)
                        self.hireCareLbl.text = "Hair Care"
                    }
                    if i["title"] == "Skincare" {
                        let image = UIImage.gif(url: i["image"].stringValue)
                        self.skincareImg.image = image
                        self.skinCareLbl.text = "Skincare"
                    }
                    if i["title"] == "Makeup" {
                        let image = UIImage.gif(url: i["image"].stringValue)
                        self.makeUpImg.image = image
                        self.makeUpLbl.text = i["title"].stringValue
                    }
                    
                    if i["title"] == "Editors Picks" {
                        //self.editorsPicks.downloaded(from: i["image"].stringValue, contentMode: .scaleAspectFill)
                        let request = ImageRequest(
                            url: URL(string: i["image"].stringValue)!
                        )
                        Nuke.loadImage(with: request, into: self.editorsPicks)
                        self.editorPickLbl.text = i["title"].stringValue
                                           
                                       }
                }
                self.activityIndicator.stopAnimating()
            }
        }
        self.bagApiCalling()
    }
    
   func bagApiCalling() {
       guard let urlToExcute = URL(string: "https://feeka.co.za/json-api/route/view_to_cart_v4.php") else {
           return
       }
       let userdefault = UserDefaults.standard
       var customerId = ""
    
//    if  userdefault.value(forKey: "customer_id") as! String != "" {
//        customerId = userdefault.value(forKey: "customer_id") as! String
//    }
    
    if userdefault.value(forKey: "customer_id") as? String != nil {
        customerId = userdefault.value(forKey: "customer_id") as! String
    } else {
        
    }
       
       let parameter = ["customer_id":"\(customerId)"]
       
       Alamofire.request(urlToExcute, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
       
       if let error = response.error {
           print(error)
           
       }
       
           if let response = response.result.value {
               let jsonResponse = JSON(response)
                                 
                   let data = jsonResponse["data"].arrayValue
               
               
               if let tabItems = self.tabBarController?.tabBar.items {
                              
                              let tabItem = tabItems[2]
                              tabItem.badgeValue = "\(data.count)"
                          }
           
           }
           
       }
   }
    
    
    @objc func grooming(tapGestureRecognizer: UITapGestureRecognizer) {
        let menGroomingVC = storyboard?.instantiateViewController(withIdentifier: "HomeMenGroomingViewController") as! HomeMenGroomingViewController
        self.navigationController?.pushViewController(menGroomingVC, animated: true)
    }
    
    @objc func brand(tapGestureRecognizer: UITapGestureRecognizer) {
        let homeProductDetails = storyboard?.instantiateViewController(withIdentifier: "BrandDetailsController") as! BrandDetailsController
        self.navigationController?.pushViewController(homeProductDetails, animated: true)
    }
    
    @objc func cooming(tapGestureRecognizer: UITapGestureRecognizer) {
        showToast(message: "Cooming Soon")
    }
    
       @objc func quizzez() {
           let QuizzesController = storyboard?.instantiateViewController(withIdentifier: "QuizzesController") 
        QuizzesController!.modalPresentationStyle = .fullScreen
        present(QuizzesController!, animated: true, completion: nil)
       }
    
    @objc func makeUP(tapGestureRecognizer: UITapGestureRecognizer) {
        let homeProductDetails = storyboard?.instantiateViewController(withIdentifier: "HomeProductDetailsViewController") as! HomeProductDetailsViewController
        homeProductDetails.categorie = "125"
        homeProductDetails.productNam = "MAKEUP"
        self.navigationController?.pushViewController(homeProductDetails, animated: true)
    }
    @objc func editor(tapGestureRecognizer: UITapGestureRecognizer) {
        let homeProductDetails = storyboard?.instantiateViewController(withIdentifier: "HomeProductDetailsViewController") as! HomeProductDetailsViewController
        homeProductDetails.tagId = "340"
        //tag
        homeProductDetails.productNam = "EDITORS PICKS"
        self.navigationController?.pushViewController(homeProductDetails, animated: true)
    }
    @objc func skin(tapGestureRecognizer: UITapGestureRecognizer) {
           let homeProductDetails = storyboard?.instantiateViewController(withIdentifier: "HomeProductDetailsViewController") as! HomeProductDetailsViewController
        homeProductDetails.categorie = "329"
        homeProductDetails.productNam = "SKIN CARE"
           self.navigationController?.pushViewController(homeProductDetails, animated: true)
       }
    @objc func hairCare(tapGestureRecognizer: UITapGestureRecognizer) {
        let homeProductDetails = storyboard?.instantiateViewController(withIdentifier: "HomeProductDetailsViewController") as! HomeProductDetailsViewController
        homeProductDetails.categorie = "337"
        homeProductDetails.productNam = "HAIR CARE"
        self.navigationController?.pushViewController(homeProductDetails, animated: true)
    }
    @objc func saleCare(tapGestureRecognizer: UITapGestureRecognizer) {
        let homeProductDetails = storyboard?.instantiateViewController(withIdentifier: "HomeProductDetailsViewController") as! HomeProductDetailsViewController
        homeProductDetails.tagId = "339"
        homeProductDetails.productNam = "SALE"
        //tag
        self.navigationController?.pushViewController(homeProductDetails, animated: true)
    }

}
