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
    
    
    @IBOutlet weak var tblView: UITableView! {
       didSet {
            tblView.delegate = self
            tblView.dataSource = self
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var cosomView: CosmosView!
    @IBOutlet weak var postView: UIView!
    @IBOutlet weak var postBtn: UIButton!
    
    var count = 2
    
    func collectionReloadData(){
        count = 5
            print(self.count)
             self.tableView.reloadData()
            print("reload data")
         
    }
}

extension ProductDetailsCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(StoredProperty.data)
        return StoredProperty.data
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell")
        //cell?.textLabel?.text = data[indexPath.row]
        print("is reloaded")
        return cell!
    }
}

