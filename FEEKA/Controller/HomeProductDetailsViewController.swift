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
import Nuke
class HomeProductDetailsViewController: UIViewController , UIViewControllerTransitioningDelegate {

    @IBOutlet weak var showTblBtn: UIButton!
    @IBOutlet weak var showHideView: UIView!
    @IBOutlet weak var showCollBtn: UIButton!
    @IBOutlet weak var cutLbl: UILabel!
    @IBOutlet weak var productListCollView: UICollectionView!
    @IBOutlet weak var productListTblView: UITableView!
    @IBOutlet weak var showHideListView: UIView!
    @IBOutlet weak var menuView: UICollectionView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var navView: UIView!
    
    var dataList = [hireCareParameter]()
    var indicator: NVActivityIndicatorView!
    var productNam: String = ""
    var categorie: String = ""
    var tagId:String = ""
    var totalPage: Int?
    var currentPage = 1
    var gender: Int = 2
    var isTotal = true
    var productCategoryList = [String]()
    var productTemrsId = [String]()
    var productID = [Int]()
    let userDefault = UserDefaults.standard
    var tag = [Int]()
    var sale = [Int]()
    var brandId = ""
    var isaddingSale = true
    var productCategorie = ""
    var productType =  ""
    var brand = ""
    var color = ""
    var filterMaxVaue = ""
    var filterMinValue = ""
    var isSort = true
    override func viewDidLoad() {
        super.viewDidLoad()
        //gender = userDefault.value(forKey: "Gender") as! Int
        userDefault.setValue(categorie, forKey: "currentCategorie")
        print(gender)
        apiCalling(brand: "", brandId: "\(brandId)", categorie: categorie, color: "", filter: "", gender: "\(gender)", maxPrice: "", minPrice: "", productCategorie: "", productType: "", searchTag: "", size: "", sortParameter: "", tagId: "\(tagId)", currentPage: currentPage)
        topApi(brand: "", brandId: "", categorie: categorie, color: "", filter: "", gender: "\(gender)", maxPrice: "", minPrice: "", productCategorie: "", productType: "", searchTag: "", size: "", sortParameter: "", tagId: "\(tagId)", currentPage: currentPage)
        self.userDefault.setValue("", forKey: "product categorie")
        self.userDefault.setValue("", forKey: "product type")
        self.userDefault.setValue("", forKey: "brand")
        self.userDefault.setValue("", forKey: "color")
        self.userDefault.setValue("", forKey: "filterMaxValue")
        self.userDefault.setValue("", forKey: "filterMinValue")

        showHideListView.layer.borderColor = UIColor.black.cgColor
        navView.setShadow()
        showHideListView.layer.borderWidth = 1
        productName.text = productNam
        showCollBtn.tintColor = .black
        showTblBtn.tintColor = .darkGray
        showHideView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideShowTable)))
        NotificationCenter.default.addObserver(self, selector: #selector(filterApi), name: Notification.Name("filterData"), object: nil)
    }
    @objc func hideShowTable() {
        
        if showCollBtn.tintColor == UIColor.black {
            productListTblView.isHidden = false
            productListCollView.isHidden = true
            self.showCollBtn.tintColor = .darkGray
            self.showTblBtn.tintColor = .black
        } else {
            productListTblView.isHidden = true
            productListCollView.isHidden = false
            self.showCollBtn.tintColor = .black
            self.showTblBtn.tintColor = .darkGray
        }
        
    }
    func topApi(brand:String, brandId:String, categorie: String,color: String,filter:String, gender: String, maxPrice: String, minPrice: String, productCategorie:String, productType: String, searchTag: String, size: String, sortParameter: String, tagId: String, currentPage: Int) {
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
             
                let productData = JSON(jsonResponse["product_data"])
              let productCategory = productData["product_categorie"].arrayValue
              
              for i in productCategory {
                  print(i)
                  print("x")
                  let jsonCategory = JSON(i)
                
                  self.productCategoryList.append(jsonCategory["name"].stringValue)
                self.productTemrsId.append(jsonCategory["term_id"].stringValue)
              }
              self.menuView.reloadData()
            
            }
            
        }
    }
    
   @objc func filterApi() {
    isTotal = true
    currentPage = 1
    dataList = [hireCareParameter]()
    productID = [Int]()
    productCategorie = userDefault.value(forKey: "product categorie") as! String
    productType =  userDefault.value(forKey: "product type") as! String
    brand = userDefault.value(forKey: "brand") as! String
    color = userDefault.value(forKey: "color") as! String
    isaddingSale = true
    filterMaxVaue = userDefault.value(forKey: "filterMaxValue") as! String
    filterMinValue = userDefault.value(forKey: "filterMinValue") as! String
        apiCalling(brand: brand, brandId: "", categorie: "\(categorie)", color: color, filter: "1", gender: "\(gender)", maxPrice: "\(filterMaxVaue)", minPrice: "\(filterMinValue)", productCategorie: "\(productCategorie)", productType: productType, searchTag: "", size: "", sortParameter: "2", tagId: "\(tagId)", currentPage: 1)
    }
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    func apiCalling(brand:String, brandId:String, categorie: String,color: String,filter:String, gender: String, maxPrice: String, minPrice: String, productCategorie:String, productType: String, searchTag: String, size: String, sortParameter: String, tagId: String, currentPage: Int) {
              indicator = self.indicator()
              indicator.startAnimating()
            if isaddingSale {
            self.tag = [Int]()
            self.sale = [Int]()
           }
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
        
        print("home page parameter : \(parameter)")
        print(urlToExcute)
              
              Alamofire.request(urlToExcute, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
              
              if let error = response.error {
                  self.indicator.stopAnimating()
                  let alertView = ShowAlertView().alertView(title: "Something went wrong", action: "OK", message: "Please try again.")
                  self.present(alertView, animated: true, completion: nil)
                  print(error)
                  
              }
              
                  if let response = response.result.value {
                      let jsonResponse = JSON(response)
                    print(response)
                    
                    if self.isTotal {
                    self.totalPage = jsonResponse["total_page"].intValue + 1
                        self.isTotal = false
                    }
                     // print(totalPage)
                      for i in jsonResponse["products"].arrayValue {
                        
                        let title = i["title"].stringValue
                        let tag = i["tag"].intValue
                        let sale = i["sale"].intValue
                        self.tag.append(tag)
                        self.sale.append(sale)
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

                        self.productListCollView.reloadData()
                        self.productListTblView.reloadData()
                      }
                      self.indicator.stopAnimating()

                                      
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
    
    func pushDiscoverController(index: Int) {
        let discoverVC = storyboard?.instantiateViewController(withIdentifier: "DiscoverDetailsViewController") as? DiscoverDetailsViewController
        discoverVC!.productId = "\(productID[index])"
        navigationController?.pushViewController(discoverVC!, animated: true)
    }



}


extension HomeProductDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == productListCollView {
            return dataList.count
        }
        return productCategoryList.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView != productListCollView {
            if indexPath.row < 2 {
            return CGSize(width: 30, height: 30)
            } else {
                let label = UILabel(frame: .zero)
                label.text = productCategoryList[indexPath.row - 2]
                label.sizeToFit()
                return CGSize(width: label.frame.width + 10, height: 30)
            }
        }
        return CGSize(width: collectionView.frame.width / 2 - 5, height: 335)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == productListCollView {
            
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as? CollectionViewCell
            //cell?.imageView.image = nil
            cell?.title.text = dataList[indexPath.row].title
            cell?.brand.text = dataList[indexPath.row].brand
            cell?.review.rating = dataList[indexPath.row].rating
            cell?.reviewText.text = "(\(dataList[indexPath.row].count))"
               cell?.imageView.image = UIImage()
           // let url = URL(string: self.dataList[indexPath.row].image)
            //cell?.imageView.downloadedFrom(url: url! , contentMode: .scaleAspectFill)
            let request = ImageRequest(
                url: URL(string: self.dataList[indexPath.row].image)!
            )
            Nuke.loadImage(with: request, into: cell!.imageView)
            
            
            if self.sale[indexPath.row] != 0 {
                cell?.sale.isHidden = false
            } else {
                cell?.sale.isHidden = true
            }
            if self.tag[indexPath.row] != 0 {
                cell?.new.isHidden = false
            } else {
                cell?.new.isHidden = true
            }
            if (dataList[indexPath.row].regularPrice).isEmpty != true {
            cell!.regularPrice.text = "R \(dataList[indexPath.row].regularPrice)"
                cell!.cutLbl.isHidden = false
            } else {
                cell!.regularPrice.text = nil
                cell!.cutLbl.isHidden = true
            }
            if (dataList[indexPath.row].salePrice).isEmpty != true {
            cell!.salePrice.text = "R \(dataList[indexPath.row].salePrice)"
                cell!.cutLbl.isHidden = false
            }else {
                cell!.salePrice.text = nil
                cell!.cutLbl.isHidden = true
            }
            return cell!
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as! HomeProductDetailsMenuCell
        if indexPath.row<2 {
            if indexPath.row == 0 {
                cell.titleBtn.setImage(UIImage(named: "1filter"), for: .normal)
            }
        }else {
            cell.titleBtn.setTitle(productCategoryList[indexPath.row - 2], for: .normal)
            cell.titleBtn.setImage(nil, for: .normal)
        }
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = UIColor.black.cgColor
        return cell
    }
    
   func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

    if indexPath.row == dataList.count - 1 {
        if totalPage! > 0 {
            currentPage += 1
            isaddingSale = false
        perform(#selector(callingApi), with: nil, afterDelay: 0.3)
            totalPage! -= 1
            
        }
    }
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView != productListCollView {
            if indexPath.row == 0 {
                
                
                let filterVC = storyboard?.instantiateViewController(withIdentifier: "fVC")
               // filterVC?.modalTransitionStyle = .coverVertical
                filterVC!.modalPresentationStyle = .overFullScreen
                filterVC!.transitioningDelegate = self
                present(filterVC!, animated: true, completion: nil)
            }else if indexPath.row == 1{
               
                let alertVC = UIAlertController(title: "SORT", message: "", preferredStyle: .actionSheet)
                alertVC.addAction(UIAlertAction(title: "Newest", style: .default, handler: { (_) in
                    self.dataList = [hireCareParameter]()
                    self.productID = [Int]()
                    self.apiCalling(brand: self.brand, brandId: "", categorie: "\(self.categorie)", color: self.color, filter: "1", gender: "\(self.gender)", maxPrice: "\(self.filterMaxVaue)", minPrice: "\(self.filterMinValue)", productCategorie: "\(self.productCategorie)", productType: self.productType, searchTag: "", size: "", sortParameter: "2", tagId: "\(self.tagId)", currentPage: 1)
                }))
                alertVC.addAction(UIAlertAction(title: "Price (low to high)", style: .default, handler: { (_) in
                    self.dataList = [hireCareParameter]()
                    self.productID = [Int]()
                    self.apiCalling(brand: self.brand, brandId: "", categorie: "\(self.categorie)", color: self.color, filter: "", gender: "\(self.gender)", maxPrice: "\(self.filterMaxVaue)", minPrice: "\(self.filterMinValue)", productCategorie: "\(self.productCategorie)", productType: self.productType, searchTag: "", size: "", sortParameter: "3", tagId: "\(self.tagId)", currentPage: 1)
                }))
                alertVC.addAction(UIAlertAction(title: "Price (high to low)", style: .default, handler: { (_) in
                    self.dataList = [hireCareParameter]()
                    self.productID = [Int]()
                    self.apiCalling(brand: self.brand, brandId: "", categorie: "\(self.categorie)", color: self.color, filter: "", gender: "\(self.gender)", maxPrice: "\(self.filterMaxVaue)", minPrice: "\(self.filterMinValue)", productCategorie: "\(self.productCategorie)", productType: self.productType, searchTag: "", size: "", sortParameter: "4", tagId: "\(self.tagId)", currentPage: 1)
                }))
                let canAction = UIAlertAction(title: "Cancle", style: .cancel) { (_) in
                    
                }
                alertVC.addAction(canAction)
                self.present(alertVC, animated: true, completion: nil)
                
            }  else if indexPath.row > 1{
                isTotal = true
                   currentPage = 1
                self.dataList = [hireCareParameter]()
                   self.productID = [Int]()
                print(dataList)
                       apiCalling(brand: "", brandId: "", categorie: "\(categorie)", color: "", filter: "1", gender: "\(gender)", maxPrice: "", minPrice: "", productCategorie: "\(productTemrsId[indexPath.row - 2])", productType: "", searchTag: "", size: "", sortParameter: "2", tagId: "\(tagId)", currentPage: 1)
            }
            
            print("selected")
        }else {
            isaddingSale = true
            pushDiscoverController(index: indexPath.row)
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
            //let url = URL(string: self.dataList[indexPath.row].image)
            //cell.productImg.downloadedFrom(url: url!, contentMode: .scaleAspectFill)
            
            let request = ImageRequest(
                           url: URL(string: self.dataList[indexPath.row].image)!
                       )
                       Nuke.loadImage(with: request, into: cell.productImg)
            
           
        
        
        cell.productLbl.text = dataList[indexPath.row].title
        cell.brand.text = dataList[indexPath.row].brand
        cell.reviewCount.text = "(\(dataList[indexPath.row].count))"
        
            cell.cosomView.rating = 4
        cell.salePrice.setBorder()
        if self.sale[indexPath.row] != 0 {
            cell.sale.isHidden = false
        } else {
            cell.sale.isHidden = true
        }
        if self.tag[indexPath.row] != 0 {
            cell.new.isHidden = false
        } else {
            cell.new.isHidden = true
        }
        if (dataList[indexPath.row].regularPrice).isEmpty != true {
                   cell.regularPrice.text = "R \(dataList[indexPath.row].regularPrice)"
                       cell.cutLbl.isHidden = false
                   } else {
                cell.regularPrice.text = nil
                cell.cutLbl.isHidden = false
                       cell.cutLbl.isHidden = true
                   }
                   if (dataList[indexPath.row].salePrice).isEmpty != true {
                   cell.salePrice.text = "R \(dataList[indexPath.row].salePrice)"
                       cell.cutLbl.isHidden = false
                   }else {
                    cell.salePrice.text = nil
                       cell.cutLbl.isHidden = true
                   }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushDiscoverController(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == dataList.count - 1 {
            if totalPage! > 0 {
                currentPage += 1
                isaddingSale = false
            perform(#selector(callingApi), with: nil, afterDelay: 0.3)
                totalPage! -= 1
                
            }
        }
    }
    
    @objc func callingApi() {
        apiCalling(brand: "", brandId: "", categorie: categorie, color: "", filter: "", gender: "\(gender)", maxPrice: "", minPrice: "", productCategorie: "", productType: "", searchTag: "", size: "", sortParameter: "", tagId: "", currentPage: currentPage)
    }
}
