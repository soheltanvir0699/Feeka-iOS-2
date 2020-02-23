//
//  ProductDetailsViewController.swift
//  FEEKA
//
//  Created by Al Mujahid Khan on 2/15/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Cosmos
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class ProductDetailsViewController: UIViewController {

    @IBOutlet weak var discriptonBorder: UILabel!
    @IBOutlet weak var infoBorder: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var reviewBorder: UILabel!
    @IBOutlet weak var salePrice: UILabel!
    @IBOutlet weak var reviewCount: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var pageTitleView: UIView!
       var imageList = [String]()
       var productTitle:String!
       var brand:String!
       var sPrice:String!
       var rPrice:String!
       var rating:Double!
       var ratingCount:Int!
       var indicator: NVActivityIndicatorView!
       var authorName = ""
       var customerId = ""
       var userdefault = UserDefaults.standard
       var currentTime:String!
       var gmtTime:String!
       var productId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        pageTitleView.setShadow()
        salePrice.text = "R\(sPrice!)"
        brandName.text = brand
        productName.text = productTitle
        cosmosView.rating = rating
        reviewCount.text = "(\(ratingCount!))"
        imgView.downloaded(from: self.imageList[0])
        imgView.contentMode = .scaleAspectFill
        setDate()
    }
    
    @IBAction func discriptionAction(_ sender: Any) {
        let indexPath = IndexPath(row: 0, section: 0)
        collView.scrollToItem(at: indexPath, at: .left, animated: true)
//        discriptonBorder.backgroundColor = .black
//        reviewBorder.backgroundColor = .white
//        infoBorder.backgroundColor = .white
    }
    @IBAction func informationAction(_ sender: Any) {
        let indexPath = IndexPath(row: 1, section: 0)
        collView.scrollToItem(at: indexPath, at: .left, animated: true)
//        discriptonBorder.backgroundColor = .white
//        reviewBorder.backgroundColor = .white
//        infoBorder.backgroundColor = .black
    }
    @IBAction func reviewAction(_ sender: Any) {
        let indexPath = IndexPath(row: 2, section: 0)
               collView.scrollToItem(at: indexPath, at: .left, animated: true)
//               discriptonBorder.backgroundColor = .white
//               infoBorder.backgroundColor = .white
//               reviewBorder.backgroundColor = .black
    }
    
    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension ProductDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ProductDetailsCollectionViewCell
        
        if indexPath.row == 0 {
        cell?.colorLabel.text = "Free delivery* in SA within 1-3 days | Free & easy returns | All Prices Vat Incl."
            cell?.colorLabel.textColor = .red
            cell?.colorLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
            let string1: String = "<span style=\"color: #ff0000;\"><strong>Free delivery* in SA within 1-3 days | Free &amp; easy returns | All prices Vat incl.</strong></span>\r\n\r\nThe TRESemmé Colour Revitalise system, with Advanced Colour Vibrancy technology, helps to keep colour vibrant for up to eight weeks.* This system, with green tea, rosemary and sunflower extracts, gently cleanses and conditions the hair to help replenish vital moisture and keep hair looking healthy. Your hair colour will be vibrant and long-lasting, while every strand is soft and manageable. For best results, use in conjunction with TRESemmé Colour Revitalise Conditioner.\r\n\r\n*TRESemmé Colour Revitalise Shampoo and Conditioner versus non-conditioning shampoo."
            cell?.sizeLabel.text = string1.htmlToString
            cell?.thirdView.isHidden = true
            discriptonBorder.backgroundColor = .black
            return cell!
            
        }else if indexPath.row == 1{
            cell?.thirdView.isHidden = true
            return cell!
        }else {
            cell?.thirdView.isHidden = false
            cell?.postView.layer.cornerRadius = 10
            cell?.postView.layer.borderWidth = 1
            cell?.postView.layer.borderColor = UIColor.black.cgColor
            cell?.cosomView.tag = indexPath.row + 1000
            cell?.commentField.tag = indexPath.row + 2000
            cell?.postBtn.tag = indexPath.row + 3000
            cell?.postBtn.addTarget(self, action: #selector(self.postReview(sender:)), for: .touchUpInside)
            return cell!
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async(execute: {
                
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ProductDetailsCollectionViewCell
         DispatchQueue.main.async {
             
//             cell!.tableView.reloadData()
//             collectionView.reloadItems(at: [indexPath])
//             cell!.tableView.reloadData()
         }
            })
    }
    
    
    fileprivate func setDate() {
        let date = Date()
        let currentFormatter = DateFormatter()
        currentFormatter.dateFormat  = "yyyy-MM-dd HH:mm:ss"
        let currentDate = currentFormatter.string(from: date)
        print(currentDate)
        self.currentTime = currentDate
        let gmtFormatter = DateFormatter()
        gmtFormatter.timeZone = TimeZone(identifier: "GMT")
        gmtFormatter.dateFormat  = "yyyy-MM-dd HH:mm:ss"
        let gmtDate = gmtFormatter.string(from: date)
        self.gmtTime = gmtDate
        print(gmtDate)
    }
    
    @objc func postReview(sender: UIButton) {
    let tag = sender.tag
    let currentRating = self.view.viewWithTag(tag - 2000) as! CosmosView
    let commentfield = self.view.viewWithTag(tag - 1000) as! UITextField
    print(currentRating.rating)
    print(commentfield.text)
    
        print("post data")
    indicator = self.indicator()
    guard let url = URL(string: "https://feeka.co.za/json-api/route/set_review.php") else {
                       self.view.makeToast( "Please try again later")
                          return
                      }
    if userdefault.value(forKey: "author_name") as? String != nil {
        self.authorName = userdefault.value(forKey: "author_name") as! String
        self.customerId = userdefault.value(forKey: "customer_id") as! String
    }
                     
                          let paramater = [
                              "comment_approved":"1",
                              "comment_author":"\(authorName)",
                            "comment_content":"\(commentfield.text!)",
                              "comment_date":"\(currentTime!)",
                              "comment_date_gmt":"\(gmtTime!)",
                              "comment_karma":"0",
                              "comment_meta":[
                                "rating":"\(currentRating.rating)",
                                "verified":"0",
                                "_ywar_imported":"1"
                            ],
                              "comment_parent":"0",
                              "comment_post_ID":"\(productId)",
                              "user_id":"\(customerId)"
                            ] as [String : Any]
                    
                            print(paramater)
                          Alamofire.request(url, method: .post, parameters: paramater, encoding: JSONEncoding.default, headers: nil).response { (response) in
                              self.indicator.startAnimating()
                              if let error = response.error {
                                  self.indicator.stopAnimating()
                                  let alertView = ShowAlertView().alertView(title: "Something went wrong", action: "OK", message: "Please try again.")
                                  self.present(alertView, animated: true, completion: nil)
                                  print(error)
                                  
                              }
                              
                              if let result = response.data {
                                  let jsonRespose = JSON(result)
                                  print(jsonRespose)
                                  print(jsonRespose["message"].stringValue)
                               self.view.makeToast( "\(jsonRespose["message"].stringValue)")
                                if jsonRespose["message"].stringValue != "You are posting comments too quickly. Slow down." {
                                    StoredProperty.reviewAllData.insert(reviewDataModel(rating: "\(currentRating.rating)", author: self.authorName, comment: commentfield.text!, date: self.currentTime), at: 0)
                                    let indexPath = IndexPath(row: tag - 3000, section: 0)
                                    let pDetailsCell = self.collView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ProductDetailsCollectionViewCell
                                    DispatchQueue.main.async {
                                                 
                                                 pDetailsCell!.tableView.reloadData()
                                                 self.collView.reloadItems(at: [indexPath])
                                                 pDetailsCell!.tableView.reloadData()
                                             }
                                    
                                }

                                  self.indicator.stopAnimating()
                              }
                          
              }
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currenindex = Int(scrollView.contentOffset.x/collView.frame.size.width)
        if currenindex == 0 {
            discriptonBorder.backgroundColor = .black
            infoBorder.backgroundColor = .white
            reviewBorder.backgroundColor = .white
        } else if currenindex == 1 {
            discriptonBorder.backgroundColor = .white
            infoBorder.backgroundColor = .black
            reviewBorder.backgroundColor = .white
        } else {
         discriptonBorder.backgroundColor = .white
            infoBorder.backgroundColor = .white
            reviewBorder.backgroundColor = .black
        }
    }

    
}

