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

class QuizzesController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tblView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? QuizessTableViewCell
             let request = ImageRequest(
                url: URL(string: self.dataList[indexPath.row].image)!
                                                                                )
        Nuke.loadImage(with: request, into: cell!.imgView)
        cell?.imgView.layer.cornerRadius = cell!.imgView.frame.width / 2
        cell?.btn.setTitle("\(self.dataList[indexPath.row].name)", for: .normal)
        cell?.selectedBackgroundView = UIView()
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataList[indexPath.row].id == "11" {
            StoredProperty.filterTopImage = UIImage(named: "skin_care_52878679")!
            let finderVc = storyboard?.instantiateViewController(withIdentifier: "FinderController") as? FinderController
            finderVc?.dataList = self.dataList
            finderVc?.index = indexPath.row
            self.navigationController?.pushViewController(finderVc!, animated: true)
        }
        if dataList[indexPath.row].id == "12" {
           StoredProperty.filterTopImage = UIImage(named: "hair_care_52878684")!
            let finderVc = storyboard?.instantiateViewController(withIdentifier: "FinderController") as? FinderController
            finderVc?.dataList = self.dataList
            finderVc?.index = indexPath.row
            self.navigationController?.pushViewController(finderVc!, animated: true)
        }
        if dataList[indexPath.row].id == "13"  {
            let QuizzesMenDetailsController = storyboard?.instantiateViewController(withIdentifier: "QuizzesMenDetailsController") as? QuizzesMenDetailsController
            //        QuizzesMenDetailsController?.modalPresentationStyle = .fullScreen
            //        present(QuizzesMenDetailsController!, animated: true, completion: nil)
            //
                    self.navigationController?.pushViewController(QuizzesMenDetailsController!, animated: true)
            StoredProperty.filterTopImage = UIImage(named: "skin_care_52878679")!
        }
    }
    
    @IBOutlet weak var navView: UIView!
    
    var indicator:NVActivityIndicatorView!
    
    var dataList = [quizzezModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // firstImg.layer.cornerRadius = firstImg.frame.width / 2
        navView.setShadow()
        
        self.quizzesApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        //present(finderVc!, animated: true, completion: nil)
        self.navigationController?.pushViewController(finderVc!, animated: true)
        
    }
    
    @IBAction func hairCare(_ sender: Any) {
        let finderVc = storyboard?.instantiateViewController(withIdentifier: "FinderController") as? FinderController
        finderVc?.dataList = self.dataList
        finderVc?.index = 1
        StoredProperty.filterTopImage = UIImage(named: "hair_care_52878684")!
//        finderVc?.modalPresentationStyle = .fullScreen
//        present(finderVc!, animated: true, completion: nil)
        self.navigationController?.pushViewController(finderVc!, animated: true)
        
    }
    
    @IBAction func menGrroming(_ sender: Any) {
        let QuizzesMenDetailsController = storyboard?.instantiateViewController(withIdentifier: "QuizzesMenDetailsController") as? QuizzesMenDetailsController
//        QuizzesMenDetailsController?.modalPresentationStyle = .fullScreen
//        present(QuizzesMenDetailsController!, animated: true, completion: nil)
//
        self.navigationController?.pushViewController(QuizzesMenDetailsController!, animated: true)
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
                                                            print(self.dataList)
                                                            
                                                                
                                                        }
                                                        self.tblView.reloadData()
                                                        DispatchQueue.main.async {
                                                             if self.dataList.count >= 1 {

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
