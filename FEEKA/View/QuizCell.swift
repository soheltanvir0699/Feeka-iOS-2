//
//  QuizCell.swift
//  FEEKA
//
//  Created by Apple Guru on 25/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Cosmos

class QuizCell: UICollectionViewCell {
    @IBOutlet weak var productImg: UIImageView!
       @IBOutlet weak var productTitle: UILabel!
       @IBOutlet weak var productBrand: UILabel!
       @IBOutlet weak var reviewView: CosmosView!
       @IBOutlet weak var reviewTitle: UILabel!
       @IBOutlet weak var regularPrice: UILabel!
       @IBOutlet weak var salePrice: UILabel!
       
       @IBOutlet weak var NEW: UILabel!
       @IBOutlet weak var SALE: UILabel!
}
