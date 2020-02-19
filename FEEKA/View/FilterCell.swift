//
//  FilterCell.swift
//  FEEKA
//
//  Created by Apple Guru on 19/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell {

    @IBOutlet weak var productLbl: UILabel!
    @IBOutlet weak var productView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
