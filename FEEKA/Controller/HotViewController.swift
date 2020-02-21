//
//  HotViewController.swift
//  FEEKA
//
//  Created by Al Mujahid Khan on 2/13/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class HotViewController: UIViewController {

    @IBOutlet weak var allFaceImg: UIImageView!
    @IBOutlet weak var brandCareImg: UIImageView!
    @IBOutlet weak var allBodyImg: UIImageView!
    @IBOutlet weak var ConditionerImg: UIImageView!
    @IBOutlet weak var tblView: UICollectionView!
    @IBOutlet weak var AllBrandLbl: UILabel!
    @IBOutlet weak var allFaceLbl: UILabel!
    @IBOutlet weak var allConditionerLbl: UILabel!
    @IBOutlet weak var allBodyLbl: UILabel!
    
    var dataList = [hireCareParameter]()
    var indicator: NVActivityIndicatorView!
    var gender: Int = 1
    var userDefault = UserDefaults.standard
    var hotListId = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        gender = userDefault.value(forKey: "Gender") as! Int
       setUpView()
        apiCalling()
    }
    
    func setUpView() {
        allFaceImg.layer.cornerRadius = 5
        brandCareImg.layer.cornerRadius = 5
        allBodyImg.layer.cornerRadius = 5
        ConditionerImg.layer.cornerRadius = 5
        allFaceImg.isUserInteractionEnabled = true
        brandCareImg.isUserInteractionEnabled = true
        allBodyImg.isUserInteractionEnabled = true
        ConditionerImg.isUserInteractionEnabled = true
        allFaceImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(allFace(tapGestureRecognizer:))))
        brandCareImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(allBrand(tapGestureRecognizer:))))
        allBodyImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(allBody(tapGestureRecognizer:))))
        ConditionerImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(allCondition(tapGestureRecognizer:))))
    }
    
    @objc func allFace(tapGestureRecognizer: UITapGestureRecognizer) {
       let menGroomingVC = storyboard?.instantiateViewController(withIdentifier: "DiscoverViewController") as! DiscoverViewController
        menGroomingVC.category = hotListId[0]
        self.navigationController?.pushViewController(menGroomingVC, animated: true)
    }
    
    
    @objc func allBrand(tapGestureRecognizer: UITapGestureRecognizer) {
         let menGroomingVC = storyboard?.instantiateViewController(withIdentifier: "DiscoverViewController") as! DiscoverViewController
        menGroomingVC.category = hotListId[1]
               self.navigationController?.pushViewController(menGroomingVC, animated: true)
    }
    
    @objc func allBody(tapGestureRecognizer: UITapGestureRecognizer) {
         let menGroomingVC = storyboard?.instantiateViewController(withIdentifier: "DiscoverViewController") as! DiscoverViewController
        menGroomingVC.category = hotListId[2]
               self.navigationController?.pushViewController(menGroomingVC, animated: true)
    }
    
    @objc func allCondition(tapGestureRecognizer: UITapGestureRecognizer) {
         let menGroomingVC = storyboard?.instantiateViewController(withIdentifier: "DiscoverViewController") as! DiscoverViewController
        menGroomingVC.category = hotListId[3]
               self.navigationController?.pushViewController(menGroomingVC, animated: true)
    }
    
    func apiCalling() {
                 indicator = self.indicator()
                 indicator.startAnimating()
                 guard let urlToExcute = URL(string: "https://feeka.co.za/json-api/route/hot_product_listing.php") else {
                     return
                 }
                 
                 let parameter = [
                                  "Gender":"\(gender)"
                                  ]
                 
                 Alamofire.request(urlToExcute, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                 
                 if let error = response.error {
                     self.indicator.stopAnimating()
                     let alertView = ShowAlertView().alertView(title: "Something went wrong", action: "OK", message: "Please try again.")
                     self.present(alertView, animated: true, completion: nil)
                     print(error)
                     
                 }
                 
                     if let response = response.result.value {
                         let jsonResponse = JSON(response)
                      
                         for i in jsonResponse["featured_product"].arrayValue {
                             
                           let title = i["title"].stringValue
                           let image = i["image"].stringValue
                             print(title)
                           let brand = i["brand"].arrayValue[0].stringValue
                           let reviewCount1 = JSON(i["review"])
                           let regularPrice = i["regular_price"].stringValue
                           let salePrice = i["sale_price"].stringValue
                           let reviewCount = reviewCount1["count"].intValue
                           let rating = reviewCount1["ratting"].doubleValue
                             print(rating)
                           self.dataList.append(hireCareParameter(title: title, image: image, brand: brand, count: reviewCount, rating: rating, regularPrice: regularPrice, salePrice: salePrice))

                         }
                        var brandCount = 0
                        for i in jsonResponse["brand_box"].arrayValue {
                        
                          let image = i["image"].stringValue
                            if brandCount == 0 {
                                self.allFaceImg.downloaded(from: image)
                                self.hotListId.append(i["id"].stringValue)
                                //name
                                self.allFaceLbl.text = "\(i["name"].stringValue)"
                            } else if brandCount == 1 {
                                self.brandCareImg.downloaded(from: image)
                                self.AllBrandLbl.text = "\(i["name"].stringValue)"
                                self.hotListId.append(i["id"].stringValue)
                            } else if brandCount == 2 {
                                self.allBodyImg.downloaded(from: image)
                                self.allBodyLbl.text = "\(i["name"].stringValue)"
                                self.hotListId.append(i["id"].stringValue)
                            } else if brandCount == 3 {
                                self.ConditionerImg.downloaded(from: image)
                                self.allConditionerLbl.text = "\(i["name"].stringValue)"
                                self.hotListId.append(i["id"].stringValue)
                            }
                            brandCount += 1

                        }
                        if jsonResponse["message"].stringValue == "No product found." {
                            let alertView = ShowAlertView().alertView(title: "No Product Found", action: "OK", message: "")
                            self.present(alertView, animated: true, completion: nil)
                        }
                         self.tblView.reloadData()
                         self.indicator.stopAnimating()
                     
                     }else {
                       let alertView = ShowAlertView().alertView(title: "No Product Found", action: "OK", message: "")
                       self.present(alertView, animated: true, completion: nil)
                   }
                     
                 }
       }

    
}

extension HotViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "list", for: indexPath) as? HotCollectionViewCell
        cell?.productImg.downloaded(from: dataList[indexPath.row].image)
        cell?.productBrand.text = dataList[indexPath.row].brand
        cell?.productTitle.text = dataList[indexPath.row].title
        cell?.regularPrice.text = "R \(dataList[indexPath.row].regularPrice)"
        cell?.salePrice.text = "R \(dataList[indexPath.row].salePrice)"
        cell?.productImg.layer.cornerRadius = 5
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let DiscoverDetailsVC = storyboard?.instantiateViewController(withIdentifier: "DiscoverDetailsViewController") as! DiscoverDetailsViewController
        self.navigationController?.pushViewController(DiscoverDetailsVC, animated: true)
        print("sdsdsd")
    }
    
}
