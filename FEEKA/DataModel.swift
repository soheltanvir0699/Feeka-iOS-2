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
    static var data = 2
    static var reviewAllData = [reviewDataModel]()
    
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

struct filterListData {
    var product_categorie: [String]
    var product_type: [String]
    var brand: [String]
    var color: [String]
    var Currency: String
    var min_price: String
    var max_price: String
}

struct wishListDataModel {
    var isNew:String
    var isSale:String
    var producId:Int
    var productName:String
    var productImage:String
    var productCurrency:String
    var rPrice:String
    var sPrice:String
    var brand:String
}

struct reviewDataModel {
    var rating:String
    var author:String
    var comment:String
    var date:String
}
