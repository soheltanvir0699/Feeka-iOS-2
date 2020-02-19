//
//  CollectionViewCell.swift
//  FEEKA
//
//  Created by Al Mujahid Khan on 2/14/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Cosmos

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var firstTextLbl: UILabel!
    @IBOutlet weak var review: CosmosView!
    @IBOutlet weak var regularPrice: UILabel!
    @IBOutlet weak var salePrice: UILabel!
    
    @IBOutlet weak var reviewText: UILabel!
}
