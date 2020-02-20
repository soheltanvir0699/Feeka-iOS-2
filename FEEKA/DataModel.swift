//
//  DataModel.swift
//  FEEKA
//
//  Created by Apple Guru on 12/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class StoredProperty {
    static var FacebookAuthsuccess = false
    
}

struct hireCareParameter {
    var title: String
    var image: String
    var brand: String
    var count: Int
    var rating: Double
    let regularPrice:String
    let salePrice:String
}

struct brandBox {
    let image: String
}
//["product_categorie", "product_type", "brand", "size", "price", "color"]
struct filterListData {
    var product_categorie: [String]
    var product_type: [String]
    var brand: [String]
    var color: [String]
    var Currency: String
    var min_price: String
    var max_price: String
}
