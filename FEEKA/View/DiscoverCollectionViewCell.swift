//
//  DiscoverCollectionViewCell.swift
//  FEEKA
//
//  Created by Apple Guru on 21/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Cosmos

class DiscoverCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var firstTextLbl: UILabel!
    @IBOutlet weak var review: CosmosView!
    @IBOutlet weak var regularPrice: UILabel!
    @IBOutlet weak var salePrice: UILabel!
    
    @IBOutlet weak var cutLbl: UILabel!
    @IBOutlet weak var sale: UILabel!
    @IBOutlet weak var new: UILabel!
    @IBOutlet weak var reviewText: UILabel!
}
