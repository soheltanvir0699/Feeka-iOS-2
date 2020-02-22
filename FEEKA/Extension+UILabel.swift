//
//  Extension+UILabel.swift
//  FEEKA
//
//  Created by Apple Guru on 22/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func setBorder() {
        let label = UILabel(frame: CGRect(x: 0, y: self.frame.maxY, width: 40, height: 1))
        label.backgroundColor = UIColor.black
        self.addSubview(label)
    }
}
