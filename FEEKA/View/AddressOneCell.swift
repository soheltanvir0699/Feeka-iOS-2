//
//  AddressOneCell.swift
//  FEEKA
//
//  Created by Apple Guru on 29/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class AddressOneCell: UITableViewCell {

    @IBOutlet weak var defaultAddress: UILabel!
       @IBOutlet weak var addressView: UIView!
       @IBOutlet weak var name: UILabel!
       @IBOutlet weak var country: UILabel!
       @IBOutlet weak var homeAdress: UILabel!
       @IBOutlet weak var suburb: UILabel!
       @IBOutlet weak var city: UILabel!
       @IBOutlet weak var postalCode: UILabel!
       @IBOutlet weak var phoneNumber: UILabel!
       @IBOutlet weak var editAddress: UIButton!
      @IBOutlet weak var deleteAddress: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
