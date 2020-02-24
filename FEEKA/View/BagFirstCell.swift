//
//  BagFirstCell.swift
//  FEEKA
//
//  Created by Apple Guru on 24/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class BagFirstCell: UITableViewCell {
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var isWishBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var brandLbl: UILabel!
    
    @IBOutlet weak var qtyBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
