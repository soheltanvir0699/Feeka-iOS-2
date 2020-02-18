//
//  AlertView.swift
//  FEEKA
//
//  Created by Apple Guru on 18/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import Foundation
import UIKit
class ShowAlertView {
    //static let ShowAlertView = ShowAlertView()
    func alertView(title: String, action:String, message: String) -> UIAlertController{
        let alertVc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVc.addAction(UIAlertAction(title: action, style: .cancel, handler: nil))
      return alertVc
    }
}
