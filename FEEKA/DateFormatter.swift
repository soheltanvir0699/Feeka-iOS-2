//
//  DateFormatter.swift
//  FEEKA
//
//  Created by Apple Guru on 23/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import Foundation

class dateFormating {
    func setDate(string: String) -> Date {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "mmm d, yyyy"
        return dateformatter.date(from: string)!
    }
}
