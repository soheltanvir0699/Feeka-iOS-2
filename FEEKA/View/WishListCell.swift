//
//  WishListCell.swift
//  FEEKA
//
//  Created by Apple Guru on 22/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Cosmos

class WishListCell: UICollectionViewCell {
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productBrand: UILabel!
    @IBOutlet weak var sPrice: UILabel!
    @IBOutlet weak var rPrice: UILabel!
    @IBOutlet weak var isWhish: UIButton!
    @IBOutlet weak var newBtn: UILabel!
    @IBOutlet weak var saleBtn: UILabel!
    @IBOutlet weak var addToBag: UIButton!
    @IBOutlet weak var cosmosView: CosmosView!
    
    @IBOutlet weak var cutLbl: UILabel!
    @IBOutlet weak var ratingCount: UILabel!
}
