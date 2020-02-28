//
//  QuizessTableViewCell.swift
//  FEEKA
//
//  Created by Apple Guru on 28/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class QuizessTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
