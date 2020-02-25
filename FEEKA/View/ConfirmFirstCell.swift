//
//  ConfirmFirstCell.swift
//  FEEKA
//
//  Created by Apple Guru on 25/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class ConfirmFirstCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bgFirstView: UIView!
    
    @IBOutlet weak var imageImg: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var brand: UILabel!
    
    @IBOutlet weak var qty: UILabel!
    
    @IBOutlet weak var price: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
