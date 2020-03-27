//
//  Extension+UIView.swift
//  FEEKA
//
//  Created by Apple Guru on 19/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func setShadow() {
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.shadowOpacity = 1
    self.layer.shadowOffset = .zero
    self.layer.shadowRadius = 2
    }
}

//xxxx
