//
//  ProductDetailsCollectionViewCell.swift
//  FEEKA
//
//  Created by Al Mujahid Khan on 2/15/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Cosmos

class ProductDetailsCollectionViewCell: UICollectionViewCell {
    var dataList = StoredProperty.reviewAllData
    
    @IBOutlet weak var tblView: UITableView! {
       didSet {
            tblView.delegate = self
            tblView.dataSource = self
        }
    }
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postBtn: UIButton!
    
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var cosomView: CosmosView!
    @IBOutlet weak var postView: UIView!
    
    var count = 2
    
    func collectionReloadData(){
             self.tableView.reloadData()
            print("reload data")
         
    }
}

extension ProductDetailsCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(StoredProperty.data)
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell") as! ProductDetailsSecondCell
        cell.authorName.text = dataList[indexPath.row].author
        cell.comment.text = dataList[indexPath.row].comment
        if dataList[indexPath.row].rating != "" {
         cell.cosomView.rating = Double(dataList[indexPath.row].rating)!
        }
        cell.selectedBackgroundView = UIView()
        cell.date.text = dataList[indexPath.row].date
        print("is reloaded")
        return cell
    }
}

