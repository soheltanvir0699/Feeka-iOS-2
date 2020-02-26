//
//  BrandDetailsController.swift
//  FEEKA
//
//  Created by Apple Guru on 26/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class BrandDetailsController: UIViewController {
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var navView: UIView!
    
    var indicator:NVActivityIndicatorView!
         var customerId = ""
         let userdefault = UserDefaults.standard
         var dataList = [brandDataModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navView.setShadow()
        self.brandsRequest()
    }
    
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    


}

extension BrandDetailsController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? BrandCell
        cell?.profileImge.layer.cornerRadius = (cell?.profileImge.frame.width)! / 2
        cell?.profileImge.layer.borderColor = UIColor.black.cgColor
        cell?.profileImge.layer.borderWidth = 1
        cell?.bgView.layer.shadowColor = UIColor.gray.cgColor
        cell?.bgView.layer.shadowOffset = .zero
        cell?.bgView.layer.shadowRadius = 1
        cell?.bgView.layer.shadowOpacity = 0.8
        cell?.bgView.layer.borderColor = UIColor.black.cgColor
        cell?.bgView.layer.borderWidth = 1
        cell?.selectedBackgroundView = UIView()
        let url = URL(string: dataList[indexPath.row].image)
        cell?.profileImge?.downloadedFrom(url: url!, contentMode: .scaleAspectFill)
        cell?.title.text = dataList[indexPath.row].name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let DiscoverViewController = storyboard?.instantiateViewController(withIdentifier: "DiscoverViewController") as! DiscoverViewController
        DiscoverViewController.brandId = self.dataList[indexPath.row].id
        DiscoverViewController.navText = "BRANDS"
        //homeProductDetails.searchTag = "Brands"
        self.navigationController?.pushViewController(DiscoverViewController, animated: true)
    }
    
    func brandsRequest() {
        indicator = self.indicator()
                  indicator.startAnimating()
                  guard let urlToExcute = URL(string: "https://feeka.co.za/json-api/route/brand_listing_v2.php") else {
                      return
                  }
               
                  
                  Alamofire.request(urlToExcute, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                  
                  if let error = response.error {
                      self.indicator.stopAnimating()
                      let alertView = ShowAlertView().alertView(title: "Something went wrong", action: "OK", message: "Please try again.")
                      self.present(alertView, animated: true, completion: nil)
                      print(error)
                      
                  }
                  
                      if let response = response.result.value {
                          let jsonResponse = JSON(response)
                                           
                       print(jsonResponse)
                      
                       if jsonResponse["status"].stringValue == "1" {
                        let data = jsonResponse["data"].arrayValue
                        for item in data {
                            let jsonData = JSON(item)
                            let id = jsonData["id"].stringValue
                            let name = jsonData["name"].stringValue
                            let image = jsonData["image"].stringValue
                            self.dataList.append(brandDataModel(name: name, image: image, id: id))
                            self.tblView.reloadData()
                        }

                       } else {
                           
                       let alertView = ShowAlertView().alertView(title: "Something went wrong", action: "OK", message: "")
                       self.present(alertView, animated: true, completion: nil)
                       self.indicator.stopAnimating()
                       }
                           
                       } else {
                           let alertView = ShowAlertView().alertView(title: "Something went wrong", action: "OK", message: "")
                           self.present(alertView, animated: true, completion: nil)
                       }
                              self.indicator.stopAnimating()
                          
                      
                  }
              }
    }
    

