//
//  TruckerCell.swift
//  FEEKA
//
//  Created by Apple Guru on 26/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class TruckerCell: UITableViewCell {
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var descripTion: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
