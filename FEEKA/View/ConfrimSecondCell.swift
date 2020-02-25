//
//  ConfrimSecondCell.swift
//  FEEKA
//
//  Created by Apple Guru on 25/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class ConfrimSecondCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var apartment: UILabel!
    
    @IBOutlet weak var company: UILabel!
    
    @IBOutlet weak var surub: UILabel!
    @IBOutlet weak var city: UILabel!
    
    @IBOutlet weak var postalCode: UILabel!
    
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var bgView2: UIView!
    
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var delivery: UILabel!
    @IBOutlet weak var promoCode: UILabel!
    @IBOutlet weak var subTotalPrice: UILabel!
    @IBOutlet weak var stander: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
