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
    

    @IBOutlet weak var TopView: UIView!
    @IBOutlet weak var collView: UICollectionView!
    var dataList = [hireCareParameter]()
    var productID = [Int]()
    var indicator: NVActivityIndicatorView!
    var totalPage: Int?
    var currentPage = 1
    var gender: Int = 1
    var isTotalPage = true
    var tagList = [Int]()
    var saleList = [Int]()
    override func viewDidLoad() {
        super.viewDidLoad()
        TopView.setShadow()
        apiCalling(brand: "", brandId: "", categorie: "", color: "", filter: "", gender: "\(gender)", maxPrice: "", minPrice: "", productCategorie: "", productType: "", searchTag: "", size: "", sortParameter: "", tagId: "", currentPage: currentPage)
    }
    

    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func apiCalling(brand:String, brandId:String, categorie: String,color: String,filter:String, gender: String, maxPrice: String, minPrice: String, productCategorie:String, productType: String, searchTag: String, size: String, sortParameter: String, tagId: String, currentPage: Int) {
              indicator = self.indicator()
              indicator.startAnimating()
              guard let urlToExcute = URL(string: "https://feeka.co.za/json-api/route/men_grooming.php") else {
                  return
              }
              
              let parameter = ["brand":"\(brand)",
                               "brand_id":"\(brandId)",
                               "categorie_id":"\(categorie)",
                               "color":"\(color)",
                               "filter_tag":"\(filter)",
                               "Gender":"\(gender)",
                               "max_price":"\(maxPrice)",
                               "min_price":"\(minPrice)",
                               "product_categorie":"\(productCategorie)",
                               "product_type":"\(productType)",
                               "search_tag":"\(searchTag)",
                               "size":"\(size)",
                               "sort_parameter":"\(sortParameter)",
                               "tag_id":"\(tagId)"]
              
              Alamofire.request(urlToExcute, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
              
              if let error = response.error {
                  self.indicator.stopAnimating()
                  let alertView = ShowAlertView().alertView(title: "Something went wrong", action: "OK", message: "Please try again.")
                  self.present(alertView, animated: true, completion: nil)
                  print(error)
                  
              }
              
                  if let response = response.result.value {
                      let jsonResponse = JSON(response)
                    if self.isTotalPage {
                    self.totalPage = jsonResponse["total_page"].intValue - 1
                        self.isTotalPage = false
                    }
                     // print(totalPage)
                      for i in jsonResponse["products"].arrayValue {
                          
                        let title = i["title"].stringValue
                        let tag = i["tag"].intValue
                        let sale = i["sale"].intValue
                        self.tagList.append(tag)
                        self.saleList.append(sale)
                        
                        let image = i["image"].stringValue
                          print(title)
                      
                        let brand = i["brand"].arrayValue[0].stringValue
                        
                        let reviewCount1 = JSON(i["review"])
                        let regularPrice = i["regular_price"].stringValue
                        let salePrice = i["sale_price"].stringValue
                        let reviewCount = reviewCount1["count"].intValue
                        let rating = reviewCount1["ratting"].doubleValue
                        let productid = i["ID"].intValue
                          print(rating)
                        self.dataList.append(hireCareParameter(title: title, image: image, brand: brand, count: reviewCount, rating: rating, regularPrice: regularPrice, salePrice: salePrice))
                        self.productID.append(productid)

                      }
                    self.collView.reloadData(); self.indicator.stopAnimating()
                  
                  }else {
                    let alertView = ShowAlertView().alertView(title: "No Product Found", action: "OK", message: "")
                    self.present(alertView, animated: true, completion: nil)
                }
                  
              }
    }
    
    func pushDiscoverController(index: Int) {
        let discoverVC = storyboard?.instantiateViewController(withIdentifier: "DiscoverDetailsViewController") as? DiscoverDetailsViewController
        discoverVC!.productId = "\(productID[index])"
        navigationController?.pushViewController(discoverVC!, animated: true)
    }
}

extension HomeMenGroomingViewController: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeGroomingCollectionViewCell
        if dataList.isEmpty != true {
        cell.productTitle.text = dataList[indexPath.row].title
        cell.productBrand.text = dataList[indexPath.row].brand
        cell.reviewView.rating = dataList[indexPath.row].rating
        cell.reviewTitle.text = "(\( dataList[indexPath.row].count))"
        }
        let url = URL(string: self.dataList[indexPath.row].image)
        cell.productImg.downloadedFrom(url: url!, contentMode: .scaleAspectFill)
        
        cell.regularPrice.text = "R \(dataList[indexPath.row].regularPrice)"
        if saleList[indexPath.row] != 0 {
            cell.SALE.isHidden = false
        } else {
            cell.SALE.isHidden = true
        }
        if tagList[indexPath.row] != 0 {
            cell.NEW.isHidden = false
        } else {
            cell.NEW.isHidden = true
        }
        
        cell.salePrice.text = "R \(dataList[indexPath.row].salePrice)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

    if indexPath.row == dataList.count - 1 {
        if totalPage! > 0 {
        perform(#selector(callingApi), with: nil, afterDelay: 0.3)
            totalPage! -= 1
            currentPage += 1
        }
    }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pushDiscoverController(index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           
           return CGSize(width: collectionView.frame.width / 2 - 5, height: 335)
       }
       
       @objc func callingApi() {
           apiCalling(brand: "", brandId: "", categorie: "", color: "", filter: "", gender: "\(gender)", maxPrice: "", minPrice: "", productCategorie: "", productType: "", searchTag: "", size: "", sortParameter: "", tagId: "", currentPage: currentPage)
       }
    
    
}
