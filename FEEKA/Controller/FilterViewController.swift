//
//  FilterViewController.swift
//  FEEKA
//
//  Created by Apple Guru on 19/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class FilterViewController: UIViewController {

    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var listTbl: UITableView!
    var indicator: NVActivityIndicatorView!
    var filterList = ["product_categorie", "product_type", "brand", "price", "color"]
    let userDefault = UserDefaults.standard
    var filterData = [filterListData]()
    var categorie = ""
    override func viewDidLoad() {
        categorie = userDefault.value(forKey: "currentCategorie") as! String
        super.viewDidLoad()
        navView.setShadow()
        
        UITableViewCell.appearance().selectedBackgroundView = UIView()
        filterApi(brand: "", brandId: "", categorie: "\(categorie)", color: "", filter: "", gender: "2", maxPrice: "", minPrice: "", productCategorie: "", productType: "", searchTag: "", size: "", sortParameter: "", tagId: "", currentPage: 1)
    }

    func filterApi (brand:String, brandId:String, categorie: String,color: String,filter:String, gender: String, maxPrice: String, minPrice: String, productCategorie:String, productType: String, searchTag: String, size: String, sortParameter: String, tagId: String, currentPage: Int) {
        self.indicator = self.indicator()
        self.indicator.startAnimating()
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
                  let alertView = ShowAlertView().alertView(title: "Something went wrong", action: "OK", message: "Please try again.")
                  self.present(alertView, animated: true, completion: nil)
                  print(error)
                  
              }
              
                  if let response = response.result.value {
                      let jsonResponse = JSON(response)
                   
                      let productData = JSON(jsonResponse["product_data"])
                    let productCategory = productData["product_categorie"].arrayValue
                    var productList = [String]()
                    var productListTerms = [String]()
                    for i in productCategory {
                        print(i)
                        print("x")
                        let jsonCategory = JSON(i)
                        productList.append(jsonCategory["name"].stringValue)
                        productListTerms.append(jsonCategory["term_id"].stringValue)
                    }
                    
                    let product_type = productData["product_type"].arrayValue
                    var typeList = [String]()
                    var typeListTerms = [String]()
                    for i in product_type {
                        print(i)
                        print("x")
                        let jsonCategory = JSON(i)
                        typeList.append(jsonCategory["name"].stringValue)
                        typeListTerms.append(jsonCategory["term_id"].stringValue)
                    }
                    
                    let brand = productData["brand"].arrayValue
                    var brandList = [String]()
                    var brandListTerms = [String]()
                    for i in brand {
                        print(i)
                        print("x")
                        let jsonCategory = JSON(i)
                    brandList.append(jsonCategory["name"].stringValue)
                        brandListTerms.append(jsonCategory["term_id"].stringValue)
                    }
                    
                    let color = productData["color"].arrayValue
                    var colorList = [String]()
                    var colorListTerms = [String]()
                    for i in color {
                        print(i)
                        print("x")
                        let jsonCategory = JSON(i)
                        colorList.append(jsonCategory["name"].stringValue)
                        colorListTerms.append(jsonCategory["term_id"].stringValue)
                                       }
                    
                    let price = productData["price"].arrayValue
                    var minPriceList = ""
                    var maxPriceList = ""
                    var currency = ""
                    for i in price {
                                          
                        let jsonCategory = JSON(i)
                                       
                     minPriceList = jsonCategory["min_price"].stringValue
                        maxPriceList = jsonCategory["max_price"].stringValue
                        currency = jsonCategory["Currency"].stringValue
                                          
                        }
                    self.filterData.append(filterListData(product_categorie: productList, product_type: typeList, brand: brandList, color: colorList, Currency: currency, min_price: minPriceList, max_price: maxPriceList))
                    self.filterData.append(filterListData(product_categorie: productListTerms, product_type: typeListTerms, brand: brandListTerms, color: colorListTerms, Currency: currency, min_price: minPriceList, max_price: maxPriceList))
                    self.indicator.stopAnimating()

                  }
                  
              }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func applyBtn(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("filterData"), object: nil)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func clearBtn(_ sender: Any) {
        userDefault.setValue("", forKey: "product categorie")
        userDefault.setValue("", forKey: "product type")
        userDefault.setValue("", forKey: "brand")
        userDefault.setValue("", forKey: "color")
        userDefault.setValue("", forKey: "filterMaxValue")
        userDefault.setValue("", forKey: "filterMinValue")
    }
    
}
extension FilterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FilterCell
        cell.productLbl.text = filterList[indexPath.row].uppercased()
        cell.productView.layer.borderColor = UIColor.black.cgColor
        cell.productView.layer.borderWidth = 1
        cell.clipsToBounds = true
        cell.separatorInset.top  = 100
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            let priceVC = storyboard?.instantiateViewController(withIdentifier: "PriceController") as! PriceController
            priceVC.maxData = filterData[0].max_price
            priceVC.minData = filterData[0].min_price
            priceVC.currency = filterData[0].Currency
            navigationController?.pushViewController(priceVC, animated: true)
            
        } else {
            let fDetailsVC = storyboard?.instantiateViewController(withIdentifier: "fDetails") as! FilterDetailsController
                   navigationController?.pushViewController(fDetailsVC, animated: true)
            if indexPath.row == 0 {
                fDetailsVC.dataList = filterData[0].product_categorie
                fDetailsVC.dataListTerms = filterData[1].product_categorie
                fDetailsVC.filterCategorie = "product categorie"
            } else if indexPath.row == 1 {
                fDetailsVC.dataList = filterData[0].product_type
                fDetailsVC.dataListTerms = filterData[1].product_type
                fDetailsVC.filterCategorie = "product type"
            }else if indexPath.row == 2 {
                fDetailsVC.dataList = filterData[0].brand
                fDetailsVC.dataListTerms = filterData[1].brand
                fDetailsVC.filterCategorie = "brand"
            } else if indexPath.row == 4 {
                fDetailsVC.dataList = filterData[0].color
                fDetailsVC.dataListTerms = filterData[1].color
                fDetailsVC.filterCategorie = "color"
            }
        }
    }
    
    
}
