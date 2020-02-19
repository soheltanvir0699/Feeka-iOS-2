//
//  HomeProductDetailsViewController.swift
//  FEEKA
//
//  Created by Al Mujahid Khan on 2/17/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class HomeProductDetailsViewController: UIViewController {

    @IBOutlet weak var showTblBtn: UIButton!
    @IBOutlet weak var showCollBtn: UIButton!
    @IBOutlet weak var productListCollView: UICollectionView!
    @IBOutlet weak var productListTblView: UITableView!
    @IBOutlet weak var showHideListView: UIView!
    @IBOutlet weak var menuView: UICollectionView!
    @IBOutlet weak var productName: UILabel!
    
    var dataList = [hireCareParameter]()
    var indicator: NVActivityIndicatorView!
    var productNam: String = ""
    var categorie: String = ""
    var totalPage: Int?
    var currentPage = 1
    var gender: Int = 1
    var isTotal = true
    var productCategory = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefault = UserDefaults.standard
        gender = userDefault.value(forKey: "Gender") as! Int
        print(gender)
        apiCalling(brand: "", brandId: "", categorie: categorie, color: "", filter: "", gender: "\(gender)", maxPrice: "", minPrice: "", productCategorie: "", productType: "", searchTag: "", size: "", sortParameter: "", tagId: "", currentPage: currentPage)
        showHideListView.layer.borderColor = UIColor.black.cgColor
        showHideListView.layer.borderWidth = 1
        productName.text = productNam
    }
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
            }
    

    func apiCalling(brand:String, brandId:String, categorie: String,color: String,filter:String, gender: String, maxPrice: String, minPrice: String, productCategorie:String, productType: String, searchTag: String, size: String, sortParameter: String, tagId: String, currentPage: Int) {
              indicator = self.indicator()
              indicator.startAnimating()
              guard let urlToExcute = URL(string: "https://feeka.co.za/json-api/route/GetProductListing.php?page=\(currentPage)") else {
                  return
              }
        guard let filterApi = URL(string:  "https://feeka.co.za/json-api/route/filter_listing.php") else {
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
              Alamofire.request(filterApi, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
              
              if let error = response.error {
                  self.indicator.stopAnimating()
                  let alertView = ShowAlertView().alertView(title: "Something went wrong", action: "OK", message: "Please try again.")
                  self.present(alertView, animated: true, completion: nil)
                  print(error)
                  
              }
              
                  if let response = response.result.value {
                      let jsonResponse = JSON(response)
                   
                      for i in jsonResponse["product_data"].arrayValue {
                          
                        var productCategory = i["product_categorie"].arrayValue
                        for j in productCategory {
                            let name = j["name"].stringValue
                            productCategory.append(name)
                        }

                      }
                      //self.indicator.stopAnimating()
                      self.productListCollView.reloadData()
                    self.productListTblView.reloadData()
                  
                  }
                  
              }
              Alamofire.request(urlToExcute, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
              
              if let error = response.error {
                  self.indicator.stopAnimating()
                  let alertView = ShowAlertView().alertView(title: "Something went wrong", action: "OK", message: "Please try again.")
                  self.present(alertView, animated: true, completion: nil)
                  print(error)
                  
              }
              
                  if let response = response.result.value {
                      let jsonResponse = JSON(response)
                    if self.isTotal {
                    self.totalPage = jsonResponse["total_page"].intValue
                        self.isTotal = false
                    }
                     // print(totalPage)
                      for i in jsonResponse["products"].arrayValue {
                          
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
                      self.indicator.stopAnimating()
                      self.productListCollView.reloadData()
                    self.productListTblView.reloadData()
                  
                  }else {
                    let alertView = ShowAlertView().alertView(title: "No Product Found", action: "OK", message: "")
                    self.present(alertView, animated: true, completion: nil)
                }
                  
              }
    }



}


extension HomeProductDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == productListCollView {
            return dataList.count
        }
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView != productListCollView {
            if indexPath.row < 3 {
            return CGSize(width: 30, height: 30)
            } else {
                let label = UILabel(frame: .zero)
                label.text = textArray[indexPath.row]
                label.sizeToFit()
                return CGSize(width: label.frame.width + 10, height: 30)
            }
        }
        return CGSize(width: collectionView.frame.width / 2 - 5, height: 335)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == productListCollView {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as? CollectionViewCell
            cell?.title.text = dataList[indexPath.row].title
            cell?.brand.text = dataList[indexPath.row].brand
            cell?.review.rating = dataList[indexPath.row].rating
            cell?.reviewText.text = "\(dataList[indexPath.row].count) review"
            cell?.imageView.downloaded(from: dataList[indexPath.row].image)
            cell!.regularPrice.text = "R \(dataList[indexPath.row].regularPrice)"
            cell!.salePrice.text = "R \(dataList[indexPath.row].salePrice)"
            return cell!
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath)
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = UIColor.black.cgColor
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
    
    @IBAction func showTableView(_ sender: Any) {
        productListTblView.isHidden = false
        productListCollView.isHidden = true
        showTblBtn.setImage(UIImage(named: "square-shape-shadow-black"), for: .normal)
        showCollBtn.setImage(UIImage(named: "four-grey-squares"), for: .normal)
    }
    
    @IBAction func showCollectionView(_ sender: Any) {
        productListTblView.isHidden = true
        productListCollView.isHidden = false
        showCollBtn.setImage(UIImage(named: "four-black-squares"), for: .normal)
        showTblBtn.setImage(UIImage(named: "square-shape-shadow-grey"), for: .normal)
    }
    
    
}

extension HomeProductDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DiscoverTableViewCell
        cell.productImg.downloaded(from: dataList[indexPath.row].image)
        cell.productLbl.text = dataList[indexPath.row].title
        cell.brand.text = dataList[indexPath.row].brand
        cell.regularPrice.text = "R \(dataList[indexPath.row].regularPrice)"
        cell.salePrice.text = "R \(dataList[indexPath.row].salePrice)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == dataList.count - 1 {
            if totalPage! > 0 {
            perform(#selector(callingApi), with: nil, afterDelay: 0.3)
                totalPage! -= 1
                currentPage += 1
            }
        }
    }
    
    @objc func callingApi() {
        apiCalling(brand: "", brandId: "", categorie: categorie, color: "", filter: "", gender: "\(gender)", maxPrice: "", minPrice: "", productCategorie: "", productType: "", searchTag: "", size: "", sortParameter: "", tagId: "", currentPage: currentPage)
    }
}
