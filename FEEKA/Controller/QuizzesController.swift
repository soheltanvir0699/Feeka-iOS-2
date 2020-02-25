//
//  QuizzesController.swift
//  FEEKA
//
//  Created by Apple Guru on 25/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//
//quizzes.php
import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class QuizzesController: UIViewController {

    @IBOutlet weak var firstBtn: UIButton!
    @IBOutlet weak var navView: UIView!
    
    @IBOutlet weak var thirdBtn: UIButton!
    @IBOutlet weak var secondBtn: UIButton!
    @IBOutlet weak var firstImg: UIImageView!
    var indicator:NVActivityIndicatorView!
    
    @IBOutlet weak var thirdImg: UIImageView!
    @IBOutlet weak var secondImg: UIImageView!
    var dataList = [quizzezModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navView.setShadow()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func skinCare(_ sender: Any) {
    }
    @IBAction func hairCare(_ sender: Any) {
    }
    
    @IBAction func menGrroming(_ sender: Any) {
    }
    
    func quizzesApi() {
                     indicator = self.indicator()
                      indicator.startAnimating()
                     
                      guard let url = URL(string: "https://feeka.co.za/json-api/route/quizzes.php") else {
                                         self.view.makeToast( "Please try again later")
                                            return
                                        }
                                            Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { (response) in
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
                                                    if jsonRespose["status"].stringValue == "2" {
                                                      
                                                       let data = jsonRespose["data"].arrayValue
                                                        for dataItem in data {
                                                            let jsonData = JSON(dataItem)
                                                            let id = jsonData["id"].stringValue
                                                            let name = jsonData["name"].stringValue
                                                            let image = jsonData["image"].stringValue
                                                            let cartId = jsonData["cat_id"].stringValue
                                                            self.dataList.append(quizzezModel(id: id, name: name, image: image, catId: cartId))
                                                        }
                                                        
                                                        
                                                       
                                                       
                                                      
                                                    } else {
                                                      
                                                       let alert = UIAlertController(title: "", message: "Something Wrong", preferredStyle: .alert)
                                                       alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                                                           self.dismiss(animated: true, completion: nil)
                                                       }))
                                                     
                                                       self.present(alert, animated: true, completion: nil)
                                                       //self.defaultAddress.isHidden = false
                                                      
                                                    }

                                                    self.indicator.stopAnimating()
                                                }
                                            
                                
                  }
    }
}
