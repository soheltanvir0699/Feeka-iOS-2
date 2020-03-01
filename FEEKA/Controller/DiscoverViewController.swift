//
//  DiscoverViewController.swift
//  FEEKA
//
//  Created by Al Mujahid Khan on 2/14/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import Nuke


class DiscoverViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDataSource,UITableViewDelegate, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var searchTxt: UILabel!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var showCollBtn: UIButton!
    @IBOutlet weak var showTableBtn: UIButton!
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var shortBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    var indicator:NVActivityIndicatorView!
    var dataList = [hireCareParameter]()
    var productID = [Int]()
    var searchTag: String = ""
    var totalPage: Int?
    var currentPage = 1
    var gender: Int = 2
    var isTotal = true
    var category = ""
    var navText = ""
    var productCategoryList = [String]()
    var productTemrsId = [String]()
    var tagList = [Int]()
    var saleList = [Int]()
    var brandId = ""

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchTableViewCell
        //let url = URL(string: dataList[indexPath.row].image)
        //cell.productImg.downloadedFrom(url: url!, contentMode: .scaleAspectFill)
        if dataList.count != 0 {
        let request2 = ImageRequest(
            url: URL(string: dataList[indexPath.row].image)!
            )
        Nuke.loadImage(with: request2, into: cell.productImg)
        cell.productLbl.text = dataList[indexPath.row].title
        cell.brand.text = dataList[indexPath.row].brand
        cell.cosomView.rating = dataList[indexPath.row].rating
        cell.review.text = "(\(dataList[indexPath.row].count))"
        }
        if (dataList[indexPath.row].regularPrice).isEmpty != true {
            cell.regularPrice.text = "R \(dataList[indexPath.row].regularPrice)"
            cell.cutLbl.isHidden = false
                      } else {
            cell.regularPrice.text = nil
            cell.cutLbl.isHidden = true
                      }
               if (dataList[indexPath.row].salePrice).isEmpty != true {
                cell.salePrice.text = "R \(dataList[indexPath.row].salePrice)"
                cell.cutLbl.isHidden = false
               } else {
                cell.salePrice.text = nil
                cell.cutLbl.isHidden = true
               }
       // cell.regularPrice.text = "R \(dataList[indexPath.row].regularPrice)"
        if saleList[indexPath.row] != 0 {
            cell.sale.isHidden = false
        } else {
            cell.sale.isHidden = true
        }
        if tagList[indexPath.row] != 0 {
            cell.new.isHidden = false
        } else {
            cell.new.isHidden = true
        }
        //cell.salePrice.text = "R \(dataList[indexPath.row].salePrice)"
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushDiscoverController(index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? DiscoverCollectionViewCell
        cell?.title.text = dataList[indexPath.row].title
        cell?.brand.text = dataList[indexPath.row].brand
        cell?.review.rating = dataList[indexPath.row].rating
        cell?.reviewText.text = "(\(dataList[indexPath.row].count))"
       // let url = URL(string: dataList[indexPath.row].image)
       // cell?.imageView.downloadedFrom(url: url!, contentMode: .scaleAspectFill)
        let request2 = ImageRequest(
                   url: URL(string: dataList[indexPath.row].image)!
                   )
               Nuke.loadImage(with: request2, into: cell!.imageView)
       // cell!.regularPrice.text = "R \(dataList[indexPath.row].regularPrice)"
        if (dataList[indexPath.row].regularPrice).isEmpty != true {
                   cell?.regularPrice.text = "R \(dataList[indexPath.row].regularPrice)"
                   cell?.cutLbl.isHidden = false
               } else {
                   cell?.regularPrice.text = nil
                   cell?.cutLbl.isHidden = true
               }
        if (dataList[indexPath.row].salePrice).isEmpty != true {
            cell?.salePrice.text = "R \(dataList[indexPath.row].salePrice)"
            cell?.cutLbl.isHidden = false
        } else {
            cell?.salePrice.text = nil
            cell?.cutLbl.isHidden = true
        }
        if saleList[indexPath.row] != 0 {
            cell!.sale.isHidden = false
        } else {
            cell?.sale.isHidden = true
        }
        if tagList[indexPath.row] != 0 {
            cell?.new.isHidden = false
        } else {
            cell?.new.isHidden = true
        }
        //cell!.salePrice.text = "R \(dataList[indexPath.row].salePrice)"
        return cell!
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == dataList.count - 1 {
            if totalPage! > 0 {
                totalPage! -= 1
                currentPage += 1
                perform(#selector(callingApi), with: nil, afterDelay: 0.3)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

    if indexPath.row == dataList.count - 1 {
        if totalPage! > 0 {
            totalPage! -= 1
            currentPage += 1
            perform(#selector(callingApi), with: nil, afterDelay: 0.3)
        }
    }
    
    }
    
    @objc func callingApi() {
        apiCalling(brand: "", brandId: "", categorie: "\(category)", color: "", filter: "", gender: "\(gender)", maxPrice: "", minPrice: "", productCategorie: "", productType: "", searchTag: "\(searchTag)", size: "", sortParameter: "", tagId: "", currentPage: currentPage)
    }

func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print("dsdsdsd")
    pushDiscoverController(index: indexPath.row)
    hideKeyBoard()
   
    }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
           return CGSize(width: collectionView.frame.width / 2 - 5, height: 335)
       }
    
    func pushDiscoverController(index: Int) {
        let discoverVC = storyboard?.instantiateViewController(withIdentifier: "DiscoverDetailsViewController") as? DiscoverDetailsViewController
        discoverVC!.productId = "\(productID[index])"
        navigationController?.pushViewController(discoverVC!, animated: true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        dismiss(animated: true, completion: nil)
        self.view.makeToast("Payment Unsuccessfull")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gender = UserDefaults.standard.value(forKey: "Gender") as! Int
        setUpView()
        navView.setShadow()
        indicator = self.indicator()
         apiCalling(brand: "", brandId: "\(brandId)", categorie: "\(category)", color: "", filter: "", gender: "\(gender)", maxPrice: "", minPrice: "", productCategorie: "", productType: "", searchTag: "\(searchTag)", size: "", sortParameter: "", tagId: "", currentPage: currentPage)
        listView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideShowTable)))
        
    }

    @objc func hideShowTable() {
        
        if showCollBtn.tintColor == UIColor.black {
            tableView.isHidden = false
            collectionView.isHidden = true
            self.showCollBtn.tintColor = .darkGray
            self.showTableBtn.tintColor = .black
        } else {
            tableView.isHidden = true
            collectionView.isHidden = false
            self.showCollBtn.tintColor = .black
            self.showTableBtn.tintColor = .darkGray
        }
        
    }
    
    func setUpView() {
        listView.layer.borderWidth = 1
        listView.layer.borderColor = UIColor.black.cgColor
        shortBtn.layer.borderWidth = 1
        shortBtn.layer.borderColor = UIColor.black.cgColor
        searchTxt.text = navText
    }
    
    
    func apiCalling(brand:String, brandId:String, categorie: String,color: String,filter:String, gender: String, maxPrice: String, minPrice: String, productCategorie:String, productType: String, searchTag: String, size: String, sortParameter: String, tagId: String, currentPage: Int) {
                indicator = self.indicator()
                indicator.startAnimating()
                guard let urlToExcute = URL(string: "https://feeka.co.za/json-api/route/GetProductListing.php?page=\(currentPage)") else {
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
                      if self.isTotal {
                      self.totalPage = jsonResponse["total_page"].intValue
                          self.isTotal = false
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
                            var brand = ""
                            if i["brand"].arrayValue.isEmpty != true {
                                brand = i["brand"].arrayValue[0].stringValue

                            }
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
                        self.indicator.stopAnimating()
                        self.tableView.reloadData()
                        self.collectionView.reloadData()

                    
                    }else {
                      let alertView = ShowAlertView().alertView(title: "No Product Found", action: "OK", message: "")
                      self.present(alertView, animated: true, completion: nil)
                  }
                    if self.dataList.count == 0 {
                        let alertView = ShowAlertView().alertView(title: "No Product Found", action: "OK", message: "")
                        self.present(alertView, animated: true, completion: nil)
                    }
                    
                }
      }
   
    
    @IBAction func sortItemAction(_ sender: Any) {
        let alert = UIAlertController(title: "Sort", message: nil, preferredStyle: .actionSheet)
        let newest = UIAlertAction(title: "Newest", style: .default) { (women) in
            
        }
       let lowToHigh = UIAlertAction(title: "Price (low to high)", style: .default) { (button) in
            
        }
    let hightToLow = UIAlertAction(title: "Price (High to low)", style: .default) { (button) in
        
    }
        let canAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            alert.removeFromParent()
        }
        alert.addAction(newest)
        alert.addAction(lowToHigh)
        alert.addAction(hightToLow)
        alert.addAction(canAction)
        alert.view.backgroundColor = .clear
        alert.view.tintColor = .black
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
    }
    @IBAction func showTableView(_ sender: Any) {
        tableView.isHidden = false
        collectionView.isHidden = true
        showTableBtn.setImage(UIImage(named: "square-shape-shadow-black"), for: .normal)
        showCollBtn.setImage(UIImage(named: "four-grey-squares"), for: .normal)
    }
    
    @IBAction func showCollectionView(_ sender: Any) {
        tableView.isHidden = true
        collectionView.isHidden = false
        showCollBtn.setImage(UIImage(named: "four-black-squares"), for: .normal)
        showTableBtn.setImage(UIImage(named: "square-shape-shadow-grey"), for: .normal)
    }
    
}
