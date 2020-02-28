//
//  FeaturedCell.swift
//  FEEKA
//
//  Created by Apple Guru on 21/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Cosmos

class FeaturedCell: UICollectionViewCell {
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var regularPrice: UILabel!    
    @IBOutlet weak var reviewCount: UILabel!
    @IBOutlet weak var salePrice: UILabel!
    @IBOutlet weak var cosomView: CosmosView!
}
