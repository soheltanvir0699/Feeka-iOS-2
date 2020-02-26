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
import Nuke

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
            //imgView.downloaded(from: self.imageList[index])
            let request = ImageRequest(
                url: URL(string: self.imageList[index])!
                )
            Nuke.loadImage(with: request, into: imgView)
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
        
        wishApi(whishStatus: isWhish)
        
        
    }
    @IBAction func addToBag(_ sender: Any) {
        wishApi(whishStatus: 3)
    }
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
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
    
    @IBAction func productDetailsAction(_ sender: Any) {
        let discoverDetailsVC = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        discoverDetailsVC.imageList = self.imageList
        discoverDetailsVC.productTitle = self.productTitle
        discoverDetailsVC.brand = self.brand
        discoverDetailsVC.sPrice = self.sPrice
        discoverDetailsVC.rating = self.rating
        discoverDetailsVC.ratingCount = self.ratingCount
        discoverDetailsVC.productId = self.productId
        self.navigationController?.pushViewController(discoverDetailsVC, animated: true)
    }
    func wishApi(whishStatus: Int) {
        guard let urlToExcute = URL(string: "https://feeka.co.za/json-api/route/wishlist_v3.php") else {
                  return
              }
        
        guard (userdefault.value(forKey: "customer_id") as? String) != nil else {
            logInVC()
            return
        }
        
        if userdefault.value(forKey: "customer_id") as? String != nil {
            customerId = userdefault.value(forKey: "customer_id") as! String
        }
    
        
              print(customerId)
              let parameter = [
                "color":"",
                "customer_id":"\(customerId)",
                "price":"\(sPrice!)",
                "product_id":"\(productId)",
                "size":"",
                "variation_id":"0",
                "whishlist_status":"\(whishStatus)"
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
                        let alert = UIAlertController(title: "", message: "Please Login ....", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInViewController")
                            self.navigationController?.pushViewController(vc!, animated: true)
                            
                            
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    if jsonResponse["status"].stringValue == "1" {
                        print(jsonResponse["message"].stringValue)
                        
                        if jsonResponse["message"].stringValue == "Item has been added to your bag." {
                            self.view.makeToast("Add to Bag")
                        }
                        self.bagApiCalling()
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
               StoredProperty.singleProductDetailsList = [singleProductDetailsModel]()
              
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
                    let content = productDetails["content"].stringValue
                    let brand = productDetails["brand"].arrayValue
                    if brand.isEmpty != true {
                        self.brand = brand[0].stringValue
                    }
                    
                    let color = productDetails["color"].arrayValue
                    var colorData = ""
                    if color.isEmpty != true {
                        colorData = color[0].stringValue
                    }
                    let size = productDetails["size"].arrayValue
                    var sizeData = ""
                    if size.isEmpty != true {
                    sizeData = size[0].stringValue
                    }
                    
                    self.rPrice = productDetails["regular_price"].stringValue
                    self.sPrice = productDetails["sale_price"].stringValue
                    let review = JSON(productDetails["review"])
                    self.ratingCount = review["count"].intValue
                    self.rating = review["ratting"].doubleValue
                    self.leftItem.text = productDetails["stock_status"].stringValue
                    StoredProperty.singleProductDetailsList.append(singleProductDetailsModel(content: content, color: colorData, size: sizeData))
                    //print(image)
                    self.scrollView.reloadInputViews()
                    self.viewUpdate()
                    
                    for index in jsonResponse["fechured_product"].arrayValue {
                        let i = JSON(index)
                        let title = i["title"].stringValue
                        let fId = i["ID"].intValue
                        let image = i["image"].stringValue
                          print(title)
                        var brand = ""
                        if i["brand"].arrayValue[0].isEmpty != true {
                             brand = i["brand"].arrayValue[0].stringValue
                        }
                        let reviewCount1 = JSON(i["review"])
                        let regularPrice = i["regular_price"].stringValue
                        let salePrice = i["sale_price"].stringValue
                        let reviewCount = reviewCount1["count"].intValue
                        let rating = reviewCount1["ratting"].doubleValue
                        self.dataList.append(hireCareParameter(title: title, image: image, brand: brand, count: reviewCount, rating: rating, regularPrice: regularPrice, salePrice: salePrice))
                        self.fechuredId.append(fId)
                        
                        let reviewData = reviewCount1["data"].arrayValue
                        for data in reviewData {
                            let singleData = JSON(data)
                            let rating = singleData["rating"].stringValue
                            let author = singleData["comment_author"].stringValue
                            let comment = singleData["comment_content"].stringValue
                            let date = singleData["comment_date"].stringValue
                            let dateformatter = DateFormatter()
                            dateformatter.dateFormat = "mmm d, yyyy"
                            let formatedDate = dateformatter.date(from: "2016-04-14 10:01:11")
                            print(formatedDate)
                            StoredProperty.reviewAllData.append(reviewDataModel(rating: rating, author: author, comment: comment, date: date))
                            
                        }

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
        //let url = URL(string: dataList[indexPath.row].image)
        //cell.productImg.downloadedFrom(url: url!, contentMode: .scaleAspectFill)
        let request = ImageRequest(
            url: URL(string: dataList[indexPath.row].image)!
            )
        Nuke.loadImage(with: request, into:  cell.productImg)
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
