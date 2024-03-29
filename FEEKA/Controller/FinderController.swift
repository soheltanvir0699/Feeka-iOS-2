//
//  FinderController.swift
//  FEEKA
//
//  Created by Apple Guru on 25/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class FinderController: UIViewController {

    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var quizBtn: UIButton!
    @IBOutlet weak var finderText: UILabel!
    @IBOutlet weak var finderDetailsTxt: UILabel!
    var dataList = [quizzezModel]()
    var index:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navView.setShadow()
        quizBtn.layer.cornerRadius = 10
        quizBtn.layer.borderColor = UIColor.gray.cgColor
        quizBtn.layer.borderWidth = 0.7
        navTitle.text = "\(dataList[index].name) FINDER"
        finderText.text = "\(dataList[index].name) FINDER"
        let fDetails = (dataList[index].name).components(separatedBy: " ")
        finderDetailsTxt.text = "Let's Find Just What Your \(fDetails[0]) Needs To Look And Feel It's Best"
    }
    override func viewWillAppear(_ animated: Bool) {
       // if StoredProperty.retake == true {
           // dismiss(animated: true , completion: nil)
       // }
        //navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func quizBtn(_ sender: Any) {
        let QuizListController = storyboard?.instantiateViewController(withIdentifier: "QuizListController") as? QuizListController
        QuizListController?.index = self.index
       // QuizListController?.modalPresentationStyle = .fullScreen
       QuizListController?.dataList = self.dataList
//        present(QuizListController!, animated: true, completion: nil)
        self.navigationController?.pushViewController(QuizListController!, animated: true)
    }
   

}
