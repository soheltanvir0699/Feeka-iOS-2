//
//  BagSecondCell.swift
//  FEEKA
//
//  Created by Apple Guru on 24/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class BagSecondCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var deliveryPrice: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
