//
//  QuizzesMenDetailsController.swift
//  FEEKA
//
//  Created by Apple Guru on 25/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class QuizzesMenDetailsController: UIViewController {

    @IBOutlet weak var firstImg: UIImageView!
    @IBOutlet weak var secondImg: UIImageView!
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var secondBtn: UIButton!
    @IBOutlet weak var firstBtn: UIButton!
    @IBOutlet weak var thirdBtn: UIButton!
    @IBOutlet weak var thirdImg: UIImageView!
    
    var dataList = [quizzezModel]()
    var qustion = [qustionModel]()
    var index:Int!
    var indicator:NVActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        firstImg.layer.cornerRadius = firstImg.frame.width / 2
        secondImg.layer.cornerRadius = firstImg.frame.width / 2
        thirdImg.layer.cornerRadius = firstImg.frame.width / 2
        navView.setShadow()
        quizzesMenApi()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if StoredProperty.retake == true {
//            dismiss(animated: true , completion: nil)
//        }
        
    }
    
    @IBAction func back(_ sender: Any) {
       // dismiss(animated: true , completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func skinCare(_ sender: Any) {
        let finderVc = storyboard?.instantiateViewController(withIdentifier: "FinderController") as? FinderController
        finderVc?.dataList = self.dataList
        finderVc?.index = 0
        StoredProperty.filterTopImage = UIImage(named: "manskin_52878681")!
//        finderVc?.modalPresentationStyle = .fullScreen
//        present(finderVc!, animated: true, completion: nil)
        self.navigationController?.pushViewController(finderVc!, animated: true)
        
    }
    
    @IBAction func hairCare(_ sender: Any) {
        let finderVc = storyboard?.instantiateViewController(withIdentifier: "FinderController") as? FinderController
        finderVc?.dataList = self.dataList
        finderVc?.index = 1
        StoredProperty.filterTopImage = UIImage(named: "manhair_care_52878682")!
//        finderVc?.modalPresentationStyle = .fullScreen
//        present(finderVc!, animated: true, completion: nil)
        
        self.navigationController?.pushViewController(finderVc!, animated: true)
        
    }
    
    @IBAction func menGrroming(_ sender: Any) {
        let finderVc = storyboard?.instantiateViewController(withIdentifier: "FinderController") as? FinderController
        finderVc?.dataList = self.dataList
        finderVc?.index = 2
        StoredProperty.filterTopImage = UIImage(named: "manbeard_care_52878683")!
//        finderVc?.modalPresentationStyle = .fullScreen
//        present(finderVc!, animated: true, completion: nil)
        self.navigationController?.pushViewController(finderVc!, animated: true)
    }
    
    func quizzesMenApi() {
        indicator = self.indicator()
       indicator.startAnimating()
                     
        guard let url = URL(string: "https://feeka.co.za/json-api/route/quizzes_men_growming.php") else {
                                         self.view.makeToast( "Please try again later")
                                            return
                                        }
        let paramater = ["cat_id":"1"]
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
                                                        DispatchQueue.main.async {
                                                             if self.dataList.count >= 2 {
                                                                                                                   
                                                    self.firstBtn.setTitle("\(self.dataList[0].name)", for: .normal)
                                                    self.secondBtn.setTitle("\(self.dataList[1].name)", for: .normal)
                                                    self.thirdBtn.setTitle("\(self.dataList[2].name)", for: .normal)
                                                    self.firstImg.downloaded(from: self.dataList[0].image)
                                                    self.secondImg.downloaded(from: self.dataList[1].image)
                                                    self.thirdImg.downloaded(from: self.dataList[2].image)
                                                                                                                   }
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
