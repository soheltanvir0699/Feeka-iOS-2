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
    var indicator: NVActivityIndicatorView!
    var totalPage: Int?
    var currentPage = 1
    var gender: Int = 1
    var isTotalPage = true
    override func viewDidLoad() {
        super.viewDidLoad()
        TopView.layer.shadowColor = UIColor.black.cgColor
        TopView.layer.shadowOpacity = 1
        TopView.layer.shadowOffset = .zero
        TopView.layer.shadowRadius = 2
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
                    self.totalPage = jsonResponse["total_page"].intValue
                        self.isTotalPage = false
                    }
                     // print(totalPage)
                      for i in jsonResponse["products"].arrayValue {
                          
                        let title = i["title"].stringValue
                        let image = i["image"].stringValue
                          print(title)
                        let brand = ""
                        let reviewCount1 = JSON(i["review"])
                        let regularPrice = i["regular_price"].stringValue
                        let salePrice = i["sale_price"].stringValue
                        let reviewCount = reviewCount1["count"].intValue
                        let rating = reviewCount1["ratting"].doubleValue
                          print(rating)
                        self.dataList.append(hireCareParameter(title: title, image: image, brand: brand, count: reviewCount, rating: rating, regularPrice: regularPrice, salePrice: salePrice))

                      }
                    self.collView.reloadData(); self.indicator.stopAnimating()
                  
                  }else {
                    let alertView = ShowAlertView().alertView(title: "No Product Found", action: "OK", message: "")
                    self.present(alertView, animated: true, completion: nil)
                }
                  
              }
    }
}

extension HomeMenGroomingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeGroomingCollectionViewCell
        cell.productTitle.text = dataList[indexPath.row].title
        cell.productBrand.text = dataList[indexPath.row].brand
        cell.reviewView.rating = dataList[indexPath.row].rating
        cell.reviewTitle.text = "\( dataList[indexPath.row].count)"
        cell.productImg.downloaded(from: dataList[indexPath.row].image)
        cell.regularPrice.text = "R \(dataList[indexPath.row].regularPrice)"
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
       
       @objc func callingApi() {
           apiCalling(brand: "", brandId: "", categorie: "", color: "", filter: "", gender: "\(gender)", maxPrice: "", minPrice: "", productCategorie: "", productType: "", searchTag: "", size: "", sortParameter: "", tagId: "", currentPage: currentPage)
       }
    
    
}