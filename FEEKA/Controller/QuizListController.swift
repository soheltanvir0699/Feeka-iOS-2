//
//  QuizListController.swift
//  FEEKA
//
//  Created by Apple Guru on 25/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class QuizListController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var question: UILabel!
    var dataList = [quizzezModel]()
    var qustion = [qustionModel]()
    var index:Int!
    var indicator:NVActivityIndicatorView!
    @IBOutlet weak var navText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        navView.setShadow()
        navText.text = "\(dataList[index].name) FINDER"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.quizListApi()
    }
   
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func quizListApi() {
        indicator = self.indicator()
            indicator.startAnimating()
           
            guard let url = URL(string: "https://feeka.co.za/json-api/route/quizzes-question-answer.php") else {
                               self.view.makeToast( "Please try again later")
                                  return
                              }
        let paramater = ["cat_id":"\(dataList[index].catId)"]
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
                                          if jsonRespose["status"].stringValue == "1" {
                                            
                                             let dataJson = JSON(jsonRespose["data"])
                                            self.question.text = dataJson["question"].stringValue
                                            let data = dataJson["data"].arrayValue
                                              for dataItem in data {
                                                  let jsonData = JSON(dataItem)
                                                  let answer = jsonData["answer"].stringValue
                                                  let tagId = jsonData["tag_id"].stringValue
                                                  let nextId = jsonData["next_question_id"].stringValue
                                                self.qustion.append(qustionModel(answer: answer, tagId: tagId, nextQuestionId: nextId))
                                              }
                                            self.tblView.reloadData()
                                             
                                            
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

extension QuizListController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return qustion.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? QuizListCellCell
        cell?.label.layer.borderWidth = 1
        cell?.label.layer.borderColor = UIColor.gray.cgColor
        cell?.label.layer.cornerRadius = 10
        cell?.label.text = qustion[indexPath.row].answer
        return cell!
    }
    
    
    
    
}
