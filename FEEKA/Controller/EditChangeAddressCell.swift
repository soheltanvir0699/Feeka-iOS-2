//
//  EditChangeAddressCell.swift
//  FEEKA
//
//  Created by Apple Guru on 5/3/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class EditChangeAddressCell: UITableViewCell {
    @IBOutlet weak var contact: UILabel!
       @IBOutlet weak var name: UILabel!
       @IBOutlet weak var apartment: UILabel!
       @IBOutlet weak var company: UILabel!
       @IBOutlet weak var street: UILabel!
       @IBOutlet weak var suburb: UILabel!
       @IBOutlet weak var city: UILabel!
       @IBOutlet weak var postalCode: UILabel!
       @IBOutlet weak var country: UILabel!
       @IBOutlet weak var deleteBtn: UIButton!
       @IBOutlet weak var editActionBtn: UIButton!
       @IBOutlet weak var addressView: UIView!
       @IBOutlet weak var selectionBtn: UIButton!
       @IBOutlet weak var imgSelect: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        
        //selectionBtn.setImage(UIImage(named: "radio-active"), for: .normal)
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
