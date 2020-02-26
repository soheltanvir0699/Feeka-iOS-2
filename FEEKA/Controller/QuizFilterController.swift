//
//  QuizFilterController.swift
//  FEEKA
//
//  Created by Apple Guru on 25/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import Nuke

class QuizFilterController: UIViewController {
    @IBOutlet weak var TopView: UIView!
    @IBOutlet weak var navtext: UILabel!
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
       var category = ""
       var tagid = [String]()
       var navtitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        TopView.setShadow()
        navtext.text = navtitle
        apiCalling(tagid: tagid, category: category)
    }
    
    @IBAction func backBtn(_ sender: Any) {
           self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
       }
       
    func apiCalling(tagid: [String], category: String ) {
                 indicator = self.indicator()
                 indicator.startAnimating()
                 guard let urlToExcute = URL(string: "https://feeka.co.za/json-api/route/get_product_list.php") else {
                     return
                 }
                 
        let parameter = ["category_id":"\(category)","tag_id":tagid] as [String : Any]
        print(parameter)
                 
                 Alamofire.request(urlToExcute, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                 
                 if let error = response.error {
                     self.indicator.stopAnimating()
                     let alertView = ShowAlertView().alertView(title: "Something went wrong", action: "OK", message: "Please try again.")
                     self.present(alertView, animated: true, completion: nil)
                     print(error)
                     
                 }
                 
                     if let response = response.result.value {
                         let jsonResponse = JSON(response)
                       
                        // print(totalPage)
                         for i in jsonResponse["products"].arrayValue {
                             
                           let title = i["title"].stringValue
                           let tag = i["tag"].intValue
                           let sale = i["sale"].intValue
                           self.tagList.append(tag)
                           self.saleList.append(sale)
                           
                           let image = i["image"].stringValue
                             print(title)
                           let brand = ""
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
        discoverVC?.modalPresentationStyle = .fullScreen
           navigationController?.pushViewController(discoverVC!, animated: true)
        present(discoverVC!, animated: true, completion: nil)
       }

   

}

extension QuizFilterController: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! QuizCell
        cell.productTitle.text = dataList[indexPath.row].title
        cell.productBrand.text = dataList[indexPath.row].brand
        cell.reviewView.rating = dataList[indexPath.row].rating
        cell.reviewTitle.text = "\( dataList[indexPath.row].count) review"
       // let url = URL(string: dataList[indexPath.row].image)
       // cell.productImg.downloadedFrom(url: url!, contentMode: .scaleAspectFill)
        let request2 = ImageRequest(
            url: URL(string: dataList[indexPath.row].image)!
            )
        Nuke.loadImage(with: request2, into: cell.productImg)
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

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pushDiscoverController(index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           
           return CGSize(width: collectionView.frame.width / 2 - 5, height: 335)
       }
    
    
}

