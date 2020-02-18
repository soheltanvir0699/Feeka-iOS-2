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

class HomeViewController: UIViewController {

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
        
        
        makeUpImg.addGestureRecognizer(tapGestureMakeUp)
        coomingSoon.addGestureRecognizer(tapGestureCooming)
        skincareImg.addGestureRecognizer(tapGestureskin)
        hairCareImg.addGestureRecognizer(tapGestureHair)
        editorsPicks.addGestureRecognizer(tapGestureEditor)
        menGroomingImg.addGestureRecognizer(tapGestureRecognizer)
        
        saleImg.addGestureRecognizer(tapGestureSale)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        activityIndicator = self.indicator()
        activityIndicator.startAnimating()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
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
                        self.coomingSoon.downloaded(from: i["image"].stringValue, contentMode: .scaleAspectFill)
                    }
                    if i["title"] == "Brands" {
                        let image = UIImage.gif(url: i["image"].stringValue)
                        self.brands.image = image
                        self.brandLbl.text = i["title"].stringValue
                    }
                    if i["id"] == "32" {
                        self.productFinder.downloaded(from: i["image"].stringValue, contentMode: .scaleAspectFill)
                    }
                    if i["title"] == "sale" {
                        let image = UIImage.gif(url: i["image"].stringValue)
                        self.saleImg.image = image
                        self.saleLbl.text = i["title"].stringValue
                    }
                    if i["title"] == "Men's Grooming" {
                        //let image = UIImage.gif(url: i["image"].stringValue)
                        self.menGroomingImg.downloaded(from: i["image"].stringValue, contentMode: .scaleAspectFill)
                        self.menGroomingLbl.text = i["title"].stringValue
                    }
                    if i["title"] == "Chocolate sqeeze title" {
                        self.bannerImg.downloaded(from: i["image"].stringValue, contentMode: .scaleAspectFill)
                    }
                    
                    if i["title"] == "Hair Care" {
                        self.hairCareImg.downloaded(from: i["image"].stringValue, contentMode: .scaleAspectFill)
                        self.hireCareLbl.text = i["title"].stringValue
                    }
                    if i["title"] == "Skincare" {
                        let image = UIImage.gif(url: i["image"].stringValue)
                        self.skincareImg.image = image
                        self.skinCareLbl.text = i["title"].stringValue
                    }
                    if i["title"] == "Makeup" {
                        let image = UIImage.gif(url: i["image"].stringValue)
                        self.makeUpImg.image = image
                        self.makeUpLbl.text = i["title"].stringValue
                    }
                    
                    if i["title"] == "Editors Picks" {
                        self.editorsPicks.downloaded(from: i["image"].stringValue, contentMode: .scaleAspectFill)
                        self.editorPickLbl.text = i["title"].stringValue
                                           
                                       }
                }
                self.activityIndicator.stopAnimating()
            }
        }
    }
//
//    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) -> UIImage{  // for swift 4.2 syntax just use ===> mode:
//        var img:UIImage = UIImage()
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard
//                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//                let data = data, error == nil,
//                   let image = UIImage(data: data)
//                else { return }
//
//            DispatchQueue.main.async() {
//                img = image
//            }
//        }.resume()
//       return img
//    }
//    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
//        guard let url = URL(string: link) else { return }
//        downloaded(from: url, contentMode: mode)
//    }
    
    @objc func grooming(tapGestureRecognizer: UITapGestureRecognizer) {
        let menGroomingVC = storyboard?.instantiateViewController(withIdentifier: "HomeMenGroomingViewController") as! HomeMenGroomingViewController
        self.navigationController?.pushViewController(menGroomingVC, animated: true)
    }
    
    @objc func cooming(tapGestureRecognizer: UITapGestureRecognizer) {
        showToast(message: "Cooming Soon")
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
