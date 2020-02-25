//
//  OrderAndReturnCell.swift
//  FEEKA
//
//  Created by Apple Guru on 25/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class OrderAndReturnCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var orderId: UILabel!
    
    @IBOutlet weak var viewOrder: UIButton!
    @IBOutlet weak var trackOrder: UIButton!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var bgView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
