//
//  HotCollectionViewCell.swift
//  FEEKA
//
//  Created by Al Mujahid Khan on 2/13/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Cosmos

class HotCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var review: CosmosView!
    
    @IBOutlet weak var cutLbl: UILabel!
    @IBOutlet weak var reviewText: UILabel!
    @IBOutlet weak var productImg: UIImageView!
    
    @IBOutlet weak var productTitle: UILabel!
    
    @IBOutlet weak var productBrand: UILabel!
    
    @IBOutlet weak var regularPrice: UILabel!
    
    @IBOutlet weak var salePrice: UILabel!
}
