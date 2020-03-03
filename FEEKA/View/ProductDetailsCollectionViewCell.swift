//
//  ProductDetailsCollectionViewCell.swift
//  FEEKA
//
//  Created by Al Mujahid Khan on 2/15/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Cosmos
import WebKit

class ProductDetailsCollectionViewCell: UICollectionViewCell {
    var dataList = StoredProperty.reviewAllData
    
    @IBOutlet weak var tblView: UITableView! {
       didSet {
            tblView.delegate = self
            tblView.dataSource = self
        }
    }
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postBtn: UIButton!
    
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var cosomView: CosmosView!
    @IBOutlet weak var postView: UIView!
    @IBOutlet weak var DescriptionLbl: UILabel!

    
    
    var count = 2
    
    func collectionReloadData(){
        dataList = StoredProperty.reviewAllData
            self.tableView.reloadData()
        print(dataList)
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
        let date = dataList[indexPath.row].date
        
        let fullNameArr = date.split{$0 == " "}.map(String.init)
        cell.date.text = fullNameArr[0]
        print("is reloaded")
        return cell
    }
}

