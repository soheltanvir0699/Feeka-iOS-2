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
import Nuke

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
        firstImg.layer.cornerRadius = firstImg.frame.width / 2
        secondImg.layer.cornerRadius = firstImg.frame.width / 2
        thirdImg.layer.cornerRadius = firstImg.frame.width / 2
        navView.setShadow()
        
        self.quizzesApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
       if StoredProperty.retake == true {
        indicator.startAnimating()
           dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func skinCare(_ sender: Any) {
        let finderVc = storyboard?.instantiateViewController(withIdentifier: "FinderController") as? FinderController
        finderVc?.dataList = self.dataList
        finderVc?.index = 0
        StoredProperty.filterTopImage = UIImage(named: "skin_care_52878679")!
        finderVc?.modalPresentationStyle = .fullScreen
        present(finderVc!, animated: true, completion: nil)
        
    }
    
    @IBAction func hairCare(_ sender: Any) {
        let finderVc = storyboard?.instantiateViewController(withIdentifier: "FinderController") as? FinderController
        finderVc?.dataList = self.dataList
        finderVc?.index = 1
        StoredProperty.filterTopImage = UIImage(named: "hair_care_52878684")!
        finderVc?.modalPresentationStyle = .fullScreen
        present(finderVc!, animated: true, completion: nil)
        
    }
    
    @IBAction func menGrroming(_ sender: Any) {
        let QuizzesMenDetailsController = storyboard?.instantiateViewController(withIdentifier: "QuizzesMenDetailsController") as? QuizzesMenDetailsController
        QuizzesMenDetailsController?.modalPresentationStyle = .fullScreen
        present(QuizzesMenDetailsController!, animated: true, completion: nil)
        
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
                                                        DispatchQueue.main.async {
                                                             if self.dataList.count >= 2 {
                                                                                                                   
                                                    self.firstBtn.setTitle("\(self.dataList[0].name)", for: .normal)
                                                    self.secondBtn.setTitle("\(self.dataList[1].name)", for: .normal)
                                                    self.thirdBtn.setTitle("\(self.dataList[2].name)", for: .normal)
                                                    self.firstImg.downloaded(from: self.dataList[0].image)
                                                                let request = ImageRequest(
                                                                    url: URL(string: self.dataList[0].image)!
                                                                    )
                                                                Nuke.loadImage(with: request, into: self.firstImg)
                                                   // self.secondImg.downloaded(from: self.dataList[1].image)
                                                                let request1 = ImageRequest(
                                                                    url: URL(string: self.dataList[1].image)!
                                                                    )
                                                                Nuke.loadImage(with: request1, into: self.secondImg)
                                                    //self.thirdImg.downloaded(from: self.dataList[2].image)
                                                                
                                                                let request2 = ImageRequest(
                                                                    url: URL(string: self.dataList[2].image)!
                                                                    )
                                                                Nuke.loadImage(with: request2, into: self.thirdImg)
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
