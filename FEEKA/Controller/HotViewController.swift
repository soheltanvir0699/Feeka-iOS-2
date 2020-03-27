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
import Nuke

class HotViewController: UIViewController {

    @IBOutlet weak var allFaceImg: UIImageView!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var brandCareImg: UIImageView!
    @IBOutlet weak var allBodyImg: UIImageView!
    @IBOutlet weak var ConditionerImg: UIImageView!
    @IBOutlet weak var tblView: UICollectionView!
    @IBOutlet weak var AllBrandLbl: UILabel!
    @IBOutlet weak var allFaceLbl: UILabel!
    @IBOutlet weak var allConditionerLbl: UILabel!
    @IBOutlet weak var allBodyLbl: UILabel!
    @IBOutlet weak var featureColl: UICollectionView!
    @IBOutlet weak var lastCollList: UICollectionView!
    
    
    var dataList = [hireCareParameter]()
    var indicator: NVActivityIndicatorView!
    var gender: Int = 1
    var userDefault = UserDefaults.standard
    var hotListId = [String]()
    var productId = [Int]()
    var hotList = [hotData]()
    let blurEffect = UIBlurEffect(style: .dark)
    var blurredEffectView = UIVisualEffectView()
    var blurredEffectView1 = UIVisualEffectView()
    var blurredEffectView2 = UIVisualEffectView()
    var blurredEffectView3 = UIVisualEffectView()
    override func viewDidLoad() {
        super.viewDidLoad()
        gender = userDefault.value(forKey: "Gender") as! Int
        navView.setShadow()
       setUpView()
        apiCalling()
        
//        let view1 = CALayer()
//        view.frame = ConditionerImg.frame
//        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
//        ConditionerImg.addSubview(view1)
//        brandCareImg.addSubview(view1)
//        allBodyImg.addSubview(view1)
//        allFaceImg.addSubview(view1)
        
        
        blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.alpha = 0.4
        blurredEffectView.frame = allFaceImg.frame
        
        blurredEffectView1 = UIVisualEffectView(effect: blurEffect)
        blurredEffectView1.alpha = 0.4
        blurredEffectView1.frame = allBodyImg.frame
        
        blurredEffectView2 = UIVisualEffectView(effect: blurEffect)
        blurredEffectView2.alpha = 0.4
        blurredEffectView2.frame = brandCareImg.frame
        
        blurredEffectView3 = UIVisualEffectView(effect: blurEffect)
        blurredEffectView3.alpha = 0.4
        blurredEffectView3.frame = ConditionerImg.frame
        
       
        
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
       let DiscoverViewController = storyboard?.instantiateViewController(withIdentifier: "DiscoverViewController") as! DiscoverViewController
        DiscoverViewController.category = hotListId[0]
        DiscoverViewController.searchTag = "HAIR MOISTURISERS"
        DiscoverViewController.navText = "HAIR MOISTURISERS"
        
        self.navigationController?.pushViewController(DiscoverViewController, animated: true)
    }
    
    
    @objc func allBrand(tapGestureRecognizer: UITapGestureRecognizer) {
         let DiscoverViewController = storyboard?.instantiateViewController(withIdentifier: "DiscoverViewController") as! DiscoverViewController
        DiscoverViewController.category = hotListId[1]
        DiscoverViewController.searchTag = "ALL SHAMPOO"
        DiscoverViewController.navText = "ALL SHAMPOO"
               self.navigationController?.pushViewController(DiscoverViewController, animated: true)
    }
    
    @objc func allBody(tapGestureRecognizer: UITapGestureRecognizer) {
         let DiscoverViewController = storyboard?.instantiateViewController(withIdentifier: "DiscoverViewController") as! DiscoverViewController
        DiscoverViewController.category = hotListId[2]
        DiscoverViewController.searchTag = "CONDITIONERS"
        DiscoverViewController.navText = "CONDITIONERS"
        self.navigationController?.pushViewController(DiscoverViewController, animated: true)
    }
    
    @objc func allCondition(tapGestureRecognizer: UITapGestureRecognizer) {
         let DiscoverViewController = storyboard?.instantiateViewController(withIdentifier: "DiscoverViewController") as! DiscoverViewController
        DiscoverViewController.category = hotListId[3]
        DiscoverViewController.searchTag = "FACE MOISTURISERS"
        DiscoverViewController.navText = "FACE MOISTURISERS"
        
               self.navigationController?.pushViewController(DiscoverViewController, animated: true)
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
                            let productid = i["ID"].intValue
                           let regularPrice = i["regular_price"].stringValue
                           let salePrice = i["sale_price"].stringValue
                           let reviewCount = reviewCount1["count"].intValue
                           let rating = reviewCount1["ratting"].doubleValue
                             print(rating)
                            
                           self.dataList.append(hireCareParameter(title: title, image: image, brand: brand, count: reviewCount, rating: rating, regularPrice: regularPrice, salePrice: salePrice))
                            self.productId.append(productid)

                         }
                        var brandCount = 0
                        for i in jsonResponse["brand_box"].arrayValue {
                        
                          let image = i["image"].stringValue
                            let name = i["name"].stringValue
                            let hotListId = i["id"].stringValue
                            self.lastCollList.reloadData()
                            self.hotList.append(hotData(title: name, image: image, hostId: hotListId))
                            if brandCount == 0 {
                               // self.allFaceImg.downloaded(from: image)
                                let request = ImageRequest(
                                    url: URL(string: image)!
                                )
                                Nuke.loadImage(with: request, into: self.allFaceImg)
                                self.hotListId.append(i["id"].stringValue)
                                //name
                                self.allFaceLbl.text = "\(i["name"].stringValue)"
                            } else if brandCount == 1 {
                               // self.brandCareImg.downloaded(from: image)
                                let request = ImageRequest(
                                    url: URL(string: image)!
                                )
                                Nuke.loadImage(with: request, into: self.brandCareImg)
                                self.AllBrandLbl.text = "\(i["name"].stringValue)"
                                self.hotListId.append(i["id"].stringValue)
                            } else if brandCount == 2 {
                               // self.allBodyImg.downloaded(from: image)
                                let request = ImageRequest(
                                    url: URL(string: image)!
                                )
                                Nuke.loadImage(with: request, into: self.allBodyImg)
                                self.allBodyLbl.text = "\(i["name"].stringValue)"
                                self.hotListId.append(i["id"].stringValue)
                            } else if brandCount == 3 {
                                //self.ConditionerImg.downloaded(from: image)
                                let request = ImageRequest(
                                    url: URL(string: image)!
                                )
                                Nuke.loadImage(with: request, into: self.ConditionerImg)
                                self.allConditionerLbl.text = "\(i["name"].stringValue)"
                                self.hotListId.append(i["id"].stringValue)
                            }
                            self.allFaceImg.addSubview(self.blurredEffectView)
                            self.allBodyImg.addSubview(self.blurredEffectView1)
                            self.brandCareImg.addSubview(self.blurredEffectView2)
                            self.ConditionerImg.addSubview(self.blurredEffectView3)
                            if self.dataList.count == 0 {
                                self.tblView.isHidden = true
                            } else {
                                self.tblView.isHidden = false
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
        if collectionView == featureColl {
        return dataList.count
        } else {
            return hotList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == featureColl {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "list", for: indexPath) as? HotCollectionViewCell
        //cell?.productImg.downloaded(from: dataList[indexPath.row].image)
        if dataList.isEmpty != true {
        let request = ImageRequest(
            url: URL(string: dataList[indexPath.row].image)!
        )
        
        Nuke.loadImage(with: request, into: cell!.productImg)
        cell?.productBrand.text = dataList[indexPath.row].brand
        cell?.productTitle.text = dataList[indexPath.row].title
        }
        if (dataList[indexPath.row].regularPrice).isEmpty != true {
            let lineView = UIView(frame: CGRect(x: 0, y: cell!.regularPrice.frame.height/2 - 0.5, width: cell!.regularPrice.frame.width, height: 1.0))
            lineView.backgroundColor = UIColor.black
            //cell!.regularPrice.addSubview(lineView)
            cell?.regularPrice.text = "R \(dataList[indexPath.row].regularPrice)"
            cell!.cutLbl.isHidden = false
        } else {
            cell?.regularPrice.text = nil
            cell!.cutLbl.isHidden = true
        }
        if (dataList[indexPath.row].salePrice).isEmpty != true {
        cell?.salePrice.text = "R \(dataList[indexPath.row].salePrice)"
            cell?.cutLbl.isHidden = false
        }else {
            cell?.salePrice.text = nil
            cell!.cutLbl.isHidden = true
        }
        //cell?.regularPrice.text = "R \(dataList[indexPath.row].regularPrice)"
        //cell?.salePrice.text = "R \(dataList[indexPath.row].salePrice)"
        if dataList.isEmpty != true {
        cell?.review.rating = dataList[indexPath.row].rating
        cell?.reviewText.text = "(\(dataList[indexPath.row].count))"
        }
        cell?.productImg.layer.cornerRadius = 5
        return cell!
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collCell", for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == featureColl {
        let DiscoverDetailsVC = storyboard?.instantiateViewController(withIdentifier: "DiscoverDetailsViewController") as! DiscoverDetailsViewController
        DiscoverDetailsVC.productId = "\(productId[indexPath.row])"
        self.navigationController?.pushViewController(DiscoverDetailsVC, animated: true)
        print("sdsdsd")
        } else {
            let DiscoverViewController = storyboard?.instantiateViewController(withIdentifier: "DiscoverViewController") as! DiscoverViewController
            DiscoverViewController.category = hotList[indexPath.row].hostId
            DiscoverViewController.searchTag = hotList[indexPath.row].title
                   DiscoverViewController.navText = hotList[indexPath.row].title
                          self.navigationController?.pushViewController(DiscoverViewController, animated: true)
        }
    }
    
}
