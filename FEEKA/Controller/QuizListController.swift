//
//  QuizListController.swift
//  FEEKA
//
//  Created by Apple Guru on 25/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class QuizListController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var navView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        navView.setShadow()
        
    }
   
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension QuizListController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? QuizListCellCell
        cell?.label.layer.borderWidth = 1
        cell?.label.layer.borderColor = UIColor.gray.cgColor
        cell?.label.layer.cornerRadius = 10
        return cell!
    }
    
    
}
