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
    static var quote: String = ""
    static var quoteId:Int = 0
    static var data = 2
    static var reviewAllData = [reviewDataModel]()
    static var singleProductDetailsList = [singleProductDetailsModel]()
    static var facebookData = [facebookResponseModel]()
    static var addressData = [getCustomerDataModel]()
    
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

struct singleProductDetailsModel {
    var content:String
    var color:String
    var size:String
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

struct facebookResponseModel {
    var id:String
    var email:String
}

struct bagDataModel {
    var title:String
    var shipping:String
    var totalPrice:String
    var quantity: String
    var id: String
    var brand:String
    var price:String
    var image:String
    var outOfStock:String
    var cardId: String
}

struct getCustomerDataModel {
    var addressId:String
    var customerId:String
    var name:String
    var surname:String
    var apartment: String
    var company:String
    var street:String
    var suburb:String
    var city:String
    var country:String
    var postalCode:String
    var contactNumber:String
}

struct quizzezModel {
    var id:String
    var name:String
    var image:String
    var catId:String
}

struct qustionModel {
    var answer:String
    var tagId:String
    var nextQuestionId:String
}

struct confirmMethodModel {
    var total:String
    var subTotal:String
    var shipping:String
}

struct confirmAddress {
    var addressId: String
    var customerId: String
    var name:String
    var sureName:String
    var contact:String
    var unitNumber:String
    var apartment:String
    var company:String
    var street:String
    var suburb:String
    var city:String
    var postalCode:String
    var country:String
}

struct confirmProductModel {
    var image:String
    var title:String
    var qty:String
    var totalPrice:String
    var brand:String
    
}

struct orderModel {
    var date:String
    var orderId:String
    var totalPrice:String
}
