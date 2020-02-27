//
//  DiscoverTableViewCell.swift
//  FEEKA
//
//  Created by Al Mujahid Khan on 2/14/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Cosmos


class DiscoverTableViewCell: UITableViewCell {

    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productLbl: UILabel!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var regularPrice: UILabel!
    @IBOutlet weak var salePrice: UILabel!
    @IBOutlet weak var new: UILabel!
    @IBOutlet weak var sale: UILabel!
    @IBOutlet weak var cutLbl: UILabel!
    @IBOutlet weak var reviewCount: UILabel!
    @IBOutlet weak var cosomView: CosmosView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
