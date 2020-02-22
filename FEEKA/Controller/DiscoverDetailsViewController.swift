//
//  DiscoverDetailsViewController.swift
//  FEEKA
//
//  Created by Al Mujahid Khan on 2/14/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Cosmos
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class DiscoverDetailsViewController: UIViewController, UIScrollViewDelegate, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var salePrice: UILabel!
    @IBOutlet weak var regularPrice: UILabel!
    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var addToFav: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var leftItem: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var reviewCount: UILabel!
    @IBOutlet weak var collView: UICollectionView!
    var productId = ""
    var isLike = false
    var indicator1:NVActivityIndicatorView!
    var imageList = [String]()
    var isWhish = 0
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var productTitle:String!
    var brand:String!
    var sPrice:String!
    var rPrice:String!
    var rating:Double!
    var ratingCount:Int!
    var customerId = ""
    var fechuredId = [Int]()
    var dataList = [hireCareParameter]()
    var userdefault = UserDefaults.standard
    
    fileprivate func wishAction() {
        if isWhish == 1 {
            addToFav.setImage(UIImage(named: "like"), for: .normal)
           isWhish = 2
        } else {
            addToFav.setImage(UIImage(named: "like-normal"), for: .normal)
            isWhish = 1
        }
    }
    
    fileprivate func viewUpdate() {
        for index in 0..<self.imageList.count {
            salePrice.text = "R\(sPrice!)"
            regularPrice.text = "R\(rPrice!)"
            brandName.text = brand
            productName.text = productTitle
            cosmosView.rating = rating
            reviewCount.text = "(\(ratingCount!))"
            self.frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            self.frame.size = self.scrollView.frame.size
            let imgView = UIImageView(frame: self.frame)
            imgView.downloaded(from: self.imageList[index])
            imgView.contentMode = .scaleAspectFit
            self.scrollView.addSubview(imgView)
            self.pageControl.numberOfPages = self.imageList.count
            
            if isWhish == 1 {
                addToFav.setImage(UIImage(named: "like"), for: .normal)
            } else if isWhish == 2 {
                addToFav.setImage(UIImage(named: "like-normal"), for: .normal)
                //isWhish = 1
            }
        }
        
        self.scrollView.contentSize = CGSize(width: (self.scrollView.frame.size.width) * CGFloat(imageList.count), height: self.scrollView.frame.size.height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        apiCalling(customerId: customerId, productId: productId)
        scrollView.delegate = self
        guard (userdefault.value(forKey: "customer_id") as? String) != nil else {
            logInVC()
            return
        }
        customerId = userdefault.value(forKey: "customer_id") as! String
        
    }
    
    func logInVC() {
        let navVc = storyboard?.instantiateViewController(withIdentifier: "loginnav")
        navVc!.modalPresentationStyle = .overFullScreen
        navVc!.transitioningDelegate = self
        present(navVc!, animated: true, completion: nil)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }

    @IBAction func addToFavorite(_ sender: Any) {
        
        wishApi()
        
    }
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func productDetailsAction(_ sender: Any) {
        let discoverDetailsVC = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController")
        self.navigationController?.pushViewController(discoverDetailsVC!, animated: true)
    }
    func wishApi() {
        guard let urlToExcute = URL(string: "https://feeka.co.za/json-api/route/wishlist_v3.php") else {
                  return
              }
        
        guard (userdefault.value(forKey: "customer_id") as? String) != nil else {
            logInVC()
            return
        }
        customerId = userdefault.value(forKey: "customer_id") as! String
        
              print(customerId)
              let parameter = [
                "color":"",
                "customer_id":"\(customerId)",
                "price":"\(sPrice!)",
                "product_id":"\(productId)",
                "size":"",
                "variation_id":"0",
                "whishlist_status":"\(isWhish)"
                ]
              self.indicator1.startAnimating()
              Alamofire.request(urlToExcute, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                
              if let error = response.error {
                  self.indicator1.stopAnimating()
                  let alertView = ShowAlertView().alertView(title: "Something went wrong", action: "OK", message: "Please try again.")
                  self.present(alertView, animated: true, completion: nil)
                  print(error)
                  
              }
              
                  if let response = response.result.value {
                      let jsonResponse = JSON(response)
                    
                    
                    if jsonResponse["message"].stringValue == "Input values are missing." {
                        print(parameter)
                        self.showToast(message: "Input values are missing.")
                    }
                    if jsonResponse["status"].stringValue == "1" {
                        print(jsonResponse["message"].stringValue)
                        print(self.isWhish)
                        self.wishAction()
                    }
                  
                  }else {
                    let alertView = ShowAlertView().alertView(title: "No Product Found", action: "OK", message: "")
                    self.present(alertView, animated: true, completion: nil)
                }
                
                self.indicator1.stopAnimating()
                
                  
              }
    }
    func apiCalling(customerId:String, productId:String ) {
              self.fechuredId = [Int]()
              self.dataList = [hireCareParameter]()
              self.imageList = [String]()
              indicator1 = self.indicator()
              
              guard let urlToExcute = URL(string: "https://feeka.co.za/json-api/route/single_product_listing_v2.php") else {
                  return
              }
        
              
              let parameter = [
                "customer_id":"\(customerId)",
                "product_id":"\(productId)"
                ]
              self.indicator1.startAnimating()
              Alamofire.request(urlToExcute, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                
              if let error = response.error {
                  self.indicator1.stopAnimating()
                  let alertView = ShowAlertView().alertView(title: "Something went wrong", action: "OK", message: "Please try again.")
                  self.present(alertView, animated: true, completion: nil)
                  print(error)
                  
              }
              
                  if let response = response.result.value {
                      let jsonResponse = JSON(response)
                    let productDetails = JSON(jsonResponse["product_detail"])
                    print("product_details: \(productDetails)")
                    print(productDetails)
                    let imageArray = productDetails["image_gallery"].arrayValue
                    for i in imageArray {
                        self.imageList.append(i.stringValue)
                    }
                    if productDetails["is_whishlist"].intValue == 0 {
                       self.isWhish = 2
                    } else {
                    self.isWhish = productDetails["is_whishlist"].intValue
                        
                    }
                    self.productTitle = productDetails["title"].stringValue
                    let brand = productDetails["brand"].arrayValue
                    self.brand = brand[0].stringValue
                    self.rPrice = productDetails["regular_price"].stringValue
                    self.sPrice = productDetails["sale_price"].stringValue
                    let review = JSON(productDetails["review"])
                    self.ratingCount = review["count"].intValue
                    self.rating = review["ratting"].doubleValue
                    self.leftItem.text = productDetails["stock_status"].stringValue
                    //print(image)
                    self.scrollView.reloadInputViews()
                    self.viewUpdate()
                    
                    for index in jsonResponse["fechured_product"].arrayValue {
                        let i = JSON(index)
                        let title = i["title"].stringValue
                        let fId = i["ID"].intValue
                        let image = i["image"].stringValue
                          print(title)
                        let brand = i["brand"].arrayValue[0].stringValue
                        let reviewCount1 = JSON(i["review"])
                        let regularPrice = i["regular_price"].stringValue
                        let salePrice = i["sale_price"].stringValue
                        let reviewCount = reviewCount1["count"].intValue
                        let rating = reviewCount1["ratting"].doubleValue
                        self.dataList.append(hireCareParameter(title: title, image: image, brand: brand, count: reviewCount, rating: rating, regularPrice: regularPrice, salePrice: salePrice))
                        self.fechuredId.append(fId)

                      }
                    self.collView.reloadData()
                      
                  
                  }else {
                    let alertView = ShowAlertView().alertView(title: "No Product Found", action: "OK", message: "")
                    self.present(alertView, animated: true, completion: nil)
                }
                
                self.indicator1.stopAnimating()
                
                if self.dataList.count == 0 {
                    let alertView = ShowAlertView().alertView(title: "No Product Found", action: "OK", message: "")
                    self.present(alertView, animated: true, completion: nil)
                }
                  
              }
    }
    
}

extension DiscoverDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "list", for: indexPath) as! FeaturedCell
        cell.productImg.downloaded(from: dataList[indexPath.row].image)
        cell.productName.text = dataList[indexPath.row].title
        cell.cosomView.rating = dataList[indexPath.row].rating
        cell.brandName.text = dataList[indexPath.row].brand
        cell.regularPrice.text = "R \(dataList[indexPath.row].regularPrice)"
        cell.salePrice.text = "R \(dataList[indexPath.row].salePrice)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        productId = "\(fechuredId[indexPath.row])"
        apiCalling(customerId: customerId, productId: productId)
    }
    
}
