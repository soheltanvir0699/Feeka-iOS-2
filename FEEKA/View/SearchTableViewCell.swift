//
//  SearchTableViewCell.swift
//  FEEKA
//
//  Created by Apple Guru on 21/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Cosmos

class SearchTableViewCell: UITableViewCell {
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productLbl: UILabel!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var cosomView: CosmosView!
    @IBOutlet weak var regularPrice: UILabel!
    @IBOutlet weak var salePrice: UILabel!
    @IBOutlet weak var new: UILabel!
    @IBOutlet weak var sale: UILabel!
    @IBOutlet weak var review: UILabel!
    @IBOutlet weak var cutLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
