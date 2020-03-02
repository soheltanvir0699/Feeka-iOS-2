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
import Nuke

class BrandDetailsController: UIViewController {
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var navView: UIView!
    
    var indicator:NVActivityIndicatorView!
         var customerId = ""
         let userdefault = UserDefaults.standard
         var dataList = [brandDataModel]()
         var carDictionary = [String:[String]]()
         var carSectionTitles = [String]()
    var imagecarDictionary = [String:[String]]()
    var imagecarSectionTitles = [String]()
         var cars: [String] = []
         var image : [String] = []

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
      let carKey = carSectionTitles[section]
       if let carValues = carDictionary[carKey] {
           return carValues.count
       }
       return 0
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
       // let url = URL(string: dataList[indexPath.row].image)
        //cell?.profileImge?.downloadedFrom(url: url!, contentMode: .scaleAspectFill)
        let carKey = carSectionTitles[indexPath.section]
        if let carValues = carDictionary[carKey] {
            cell?.title?.text = carValues[indexPath.row]
            
        }
       // let carKey2 = imagecarSectionTitles[indexPath.section]
        if let carValues2 = imagecarDictionary[carKey] {
          
        }
        let request2 = ImageRequest(
                       url: URL(string: image[indexPath.row])!
                       )
                   Nuke.loadImage(with: request2, into: cell!.profileImge)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let DiscoverViewController = storyboard?.instantiateViewController(withIdentifier: "DiscoverViewController") as! DiscoverViewController
        DiscoverViewController.brandId = self.dataList[indexPath.row].id
        DiscoverViewController.navText = "BRANDS"
        //homeProductDetails.searchTag = "Brands"
        self.navigationController?.pushViewController(DiscoverViewController, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return carSectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return carSectionTitles[section]
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return carSectionTitles
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
                            self.cars.append(name)
                            self.image.append(image)
                            }
//                        self.brandSelectionTitle = []
//                        self.brandDictionary = [String:[String]]()
//                        self.brandNameData = [String]()
                        for car in self.cars {
                                let carKey = String(car.prefix(1))
                                if var carValues = self.carDictionary[carKey] {
                                    carValues.append(car)
                                    self.carDictionary[carKey] = carValues
                                } else {
                                    self.carDictionary[carKey] = [car]
                                }
                            }
                        for car in self.image {
                                                       let carKey = String(car.prefix(1))
                                                       if var carValues = self.imagecarDictionary[carKey] {
                                                           carValues.append(car)
                                                           self.imagecarDictionary[carKey] = carValues
                                                       } else {
                                                           self.imagecarDictionary[carKey] = [car]
                                                       }
                                                   }
                            
                        self.carSectionTitles = [String](self.carDictionary.keys)
                        self.imagecarSectionTitles = [String](self.imagecarDictionary.keys)
                        self.carSectionTitles = self.carSectionTitles.sorted(by: {$0 < $1})
                      //  self.imagecarSectionTitles = self.imagecarSectionTitles.sorted(by: {$0 < $1})
                        self.tblView.reloadData()

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
    

