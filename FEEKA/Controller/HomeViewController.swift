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
import SVProgressHUD

class HomeViewController: UIViewController {

    @IBOutlet weak var brands: UIImageView!
    @IBOutlet weak var bannerImg: UIImageView!
    @IBOutlet weak var coomingSoon: UIImageView!
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let urlToExcute = URL(string: "https://feeka.co.za/json-api/route/dashboard.php") else {
            return
        }
        let parameter: [String:String] = ["Gender":"2"]
        Alamofire.request(urlToExcute, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            //SVProgressHUD.show()
            if let respose = response.result.value {
                let jsonResponse = JSON(respose)
                let dataList = jsonResponse["data"].arrayValue
                 for i in dataList {
                                    let image = i["image"].stringValue
                                    print(image)
                    if i["title"] == "EQUIPMENT" {
                        self.coomingSoon.downloaded(from: i["image"].stringValue, contentMode: .scaleAspectFill)
                    }
                    if i["title"] == "Brands" {
                        let image = UIImage.gif(url: i["image"].stringValue)
                        self.brands.image = image
                    }
                    if i["title"] == "Brands" {
                        let image = UIImage.gif(url: i["image"].stringValue)
                        self.brands.image = image
                    }
                    if i["title"] == "Men's Grooming" {
                        let image = UIImage.gif(url: i["image"].stringValue)
                        self.menGroomingImg.image = image
                    }
                    if i["title"] == "Chocolate sqeeze title" {
                        self.bannerImg.downloaded(from: i["image"].stringValue, contentMode: .scaleAspectFill)
                    }
                    
                    if i["title"] == "Hair Care" {
                        self.hairCareImg.downloaded(from: i["image"].stringValue, contentMode: .scaleAspectFill)
                    }
                    if i["title"] == "Skincare" {
                        let image = UIImage.gif(url: i["image"].stringValue)
                        self.skincareImg.image = image
                    }
                    if i["title"] == "Makeup" {
                        let image = UIImage.gif(url: i["image"].stringValue)
                        self.makeUpImg.image = image
                    }
                    
                    if i["title"] == "Editors Picks" {
                        self.editorsPicks.downloaded(from: i["image"].stringValue, contentMode: .scaleAspectFill)
                                           
                                       }
                }
                //SVProgressHUD.dismiss()
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
