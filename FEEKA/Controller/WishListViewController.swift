//
//  WishListViewController.swift
//  FEEKA
//
//  Created by Al Mujahid Khan on 2/16/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class WishListViewController: UIViewController, UIViewControllerTransitioningDelegate {
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var collView: UICollectionView!
    var indicator: NVActivityIndicatorView!
    var customerId:String!
    let userdefault = UserDefaults.standard
    var wishListData = [wishListDataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navView.setShadow()
        indicator = self.indicator()
        wishApi()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func wishApi() {
        guard let urlToExcute = URL(string: "https://feeka.co.za/json-api/route/get_wishlist_v2.php") else {
                  return
              }
        
        if (userdefault.value(forKey: "customer_id") as? String) != nil  {
            customerId = userdefault.value(forKey: "customer_id") as? String
        }
        else {
            logIn()
            return
        }
        
        
              let parameter = [
                "color":"",
                "customer_id":"\(customerId!)",
                "price":"",
                "product_id":"",
                "size":"",
                "variation_id":"0",
                "whishlist_status":""
                ]
              self.indicator.startAnimating()
              Alamofire.request(urlToExcute, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                
              if let error = response.error {
                  self.indicator.stopAnimating()
                  let alertView = ShowAlertView().alertView(title: "Something went wrong", action: "OK", message: "Please try again.")
                  self.present(alertView, animated: true, completion: nil)
                  print(error)
                  
              }
              
                  if let response = response.result.value {
                      let jsonResponse = JSON(response)
                    
                    let dataArray = jsonResponse["data"].arrayValue
                    if dataArray.isEmpty == true {
                        self.collView.isHidden = true
                        
                    } else {
                        self.collView.isHidden = false
                    }
                    for dataValue in dataArray {
                        let productList = JSON(dataValue)
                        
                        let isNew = productList["IsNew"].stringValue
                        
                        let isSale = productList["IsSale"].stringValue
                        let productDtails = JSON(productList["product_detail"])
                        print("shText: \(productDtails)")
                        let productId = productDtails["id"].intValue
                        let productName = productDtails["title"].stringValue
                        print("productName: \(productName)")
                        let productImage = productDtails["featured_src"].stringValue
                        print(productImage)
                        let productCurrency = productDtails["currency"].stringValue
                        let rPrice = productDtails["regular_price"].stringValue
                        let sPrice = productDtails["sale_price"].stringValue
                        let attributes = productDtails["attributes"].arrayValue
                        var name = ""
                        for (i,attData) in attributes.enumerated() {
                            if i == 0 {
                        let jsonName = JSON(attData)
                                name = jsonName["options"].arrayValue[0].stringValue
                            }
                            
                        }
                        self.wishListData.append(wishListDataModel(isNew: isNew, isSale: isSale, producId: productId, productName: productName, productImage: productImage, productCurrency: productCurrency, rPrice: rPrice, sPrice: sPrice, brand: name))
                        
                        
                        self.collView.reloadData()
                    }
                    
                    if jsonResponse["message"].stringValue == "Input values are missing." {
                        print(parameter)
                        self.view.makeToast( "Input values are missing.")
                    }
                    if jsonResponse["status"].stringValue == "1" {
                        print(jsonResponse["message"].stringValue)
                        
                    } else if jsonResponse["status"].stringValue == "2"{
                 self.view.makeToast(jsonResponse["message"].stringValue)
                    }
                  
                  }else {
                    let alertView = ShowAlertView().alertView(title: "No Product Found", action: "OK", message: "")
                    self.present(alertView, animated: true, completion: nil)
                }
                
                self.indicator.stopAnimating()
                
                  
              }
    }
    
    func logIn() {
        let navVc = storyboard?.instantiateViewController(withIdentifier: "loginnav")
        navVc!.modalPresentationStyle = .overFullScreen
        navVc!.transitioningDelegate = self
        present(navVc!, animated: true, completion: nil)
    }
    
}


extension WishListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wishListData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wishCell", for: indexPath) as! WishListCell
        cell.productName.text = wishListData[indexPath.row].productName
        cell.productBrand.text = wishListData[indexPath.row].brand
        cell.sPrice.text = "\(wishListData[indexPath.row].productCurrency) \(wishListData[indexPath.row].sPrice)"
        cell.rPrice.text = " \(wishListData[indexPath.row].productCurrency) \(wishListData[indexPath.row].rPrice)"
        let url = URL(string: wishListData[indexPath.row].productImage)
        cell.productImg.downloadedFrom(url: url!, contentMode: .scaleAspectFill)
        
        cell.isWhish.tag = indexPath.row + 1000
        cell.addToBag.tag = indexPath.row + 2000
        cell.isWhish.addTarget(self, action: #selector(removeWhish(sender:)), for: .touchUpInside)
        cell.addToBag.addTarget(self, action: #selector(addTOBag(sender:)), for: .touchUpInside)
        if wishListData[indexPath.row].isNew == "1" {
            cell.newBtn.isHidden = false
        } else {
           cell.newBtn.isHidden = true
        }
        if wishListData[indexPath.row].isSale == "1" {
            cell.saleBtn.isHidden = false
        } else {
           cell.saleBtn.isHidden = true
        }
        return cell
    }
    @objc func removeWhish(sender: UIButton) {
        print("wish clicked")
        let tag = sender.tag
        
        print(wishListData[tag-1000].sPrice)
        removeAddBag(price: wishListData[tag-1000].sPrice, productId: wishListData[tag-1000].producId, whishStatus: "2", tag: tag, minusTag: 1000)
            
        }
    @objc func addTOBag(sender: UIButton) {
    print("wish clicked")
    let tag = sender.tag
        removeAddBag(price: wishListData[tag-2000].sPrice, productId: wishListData[tag-2000].producId, whishStatus: "3", tag: tag, minusTag: 2000)
        
    }
    func bagApiCalling() {
        guard let urlToExcute = URL(string: "https://feeka.co.za/json-api/route/view_to_cart_v4.php") else {
            return
        }
        let userdefault = UserDefaults.standard
        var customerId = ""
        if  userdefault.value(forKey: "customer_id") as! String != "" {
            customerId = userdefault.value(forKey: "customer_id") as! String
        }
        
        if userdefault.value(forKey: "customer_id") as? String != nil {
            customerId = userdefault.value(forKey: "customer_id") as! String
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
     
     
    func removeAddBag(price:String, productId:Int, whishStatus:String,tag:Int, minusTag: Int) {
        guard let urlToExcute = URL(string: "https://feeka.co.za/json-api/route/wishlist_v3.php") else {
                  return
              }
        
              print(customerId!)
              let parameter = [
                "color":"",
                "customer_id":"\(customerId!)",
                "price":"\(price)",
                "product_id":"\(productId)",
                "size":"",
                "variation_id":"0",
                "whishlist_status":"\(whishStatus)"
                ]
              print(parameter)
              self.indicator.startAnimating()
              Alamofire.request(urlToExcute, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                
              if let error = response.error {
                  self.indicator.stopAnimating()
                  let alertView = ShowAlertView().alertView(title: "Something went wrong", action: "OK", message: "Please try again.")
                  self.present(alertView, animated: true, completion: nil)
                  print(error)
                  
              }
              
                  if let response = response.result.value {
                      let jsonResponse = JSON(response)
                    
                    
                    if jsonResponse["message"].stringValue == "Input values are missing." {
                        print(parameter)
                        self.view.makeToast( "Input values are missing.")
                    }
                    if jsonResponse["status"].stringValue == "1" {
                        print(jsonResponse["message"].stringValue)
                        self.view.makeToast( jsonResponse["message"].stringValue)
                        self.wishListData.remove(at: tag-minusTag)
                        self.collView.reloadData()
                        self.bagApiCalling()
                        
                    }
                  
                  }else {
                    let alertView = ShowAlertView().alertView(title: "No Product Found", action: "OK", message: "")
                    self.present(alertView, animated: true, completion: nil)
                }
                
                self.indicator.stopAnimating()
                
                  
              }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2 - 5, height: 379)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //customerId: customerId, productId: productId
        let DiscoverDetailsVC = storyboard?.instantiateViewController(withIdentifier: "DiscoverDetailsViewController") as! DiscoverDetailsViewController
        DiscoverDetailsVC.productId = "\(wishListData[indexPath.row].producId)"
        self.navigationController?.pushViewController(DiscoverDetailsVC, animated: true)
    }
}
