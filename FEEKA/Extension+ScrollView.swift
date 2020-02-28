//
//  Extension+ScrollView.swift
//  FEEKA
//
//  Created by Apple Guru on 28/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import Foundation
import UIKit
extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
   }
}
