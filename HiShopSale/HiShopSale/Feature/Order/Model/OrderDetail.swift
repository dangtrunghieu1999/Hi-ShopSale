//
//  OrderDetail.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 13/08/2021.
//

import UIKit
import SwiftyJSON
import Alamofire

class OrderDetail: NSObject, JSONParsable {
    var orderId: Int                       = 0
    var orderCode: String                  = ""
    var orderTime: String                  = ""
    var deliveryTime: String               = ""
    
    var transporter: String                = ""
    var paymentMethod: String              = ""
    var userInfo: String                   = ""
    var address: String                    = ""
    
    var products: [Product]                = []
    var tempMoney: Double                  = 0.0
    var feeShip: Double                    = 0.0
    var totalMoney: Double                 = 0.0
    var isPaymentOnline: Int               = 0
    var status: Int                        = 0
    
    var estimateHeight: CGFloat {
        return CGFloat(products.count) * 100.0
    }
    
    required override init() { }
    
    required init(json: JSON) {
        orderId         = json["id"].intValue
        orderCode       = json["orderCode"].stringValue
        orderTime       = json["orderTime"].stringValue
        deliveryTime    = json["deliveryTime"].stringValue
        transporter     = json["transportedName"].stringValue
        paymentMethod   = json["paymentName"].stringValue
        userInfo        = json["infor"].stringValue
        address         = json["address"].stringValue
        products        = json["product"].arrayValue.map{ Product(json: $0)}
        tempMoney       = json["tempPrice"].doubleValue
        feeShip         = json["feeShip"].doubleValue
        totalMoney      = json["totalMoney"].doubleValue
        isPaymentOnline = json["isPaymentOnline"].intValue
        status          = json["status"].intValue
    }
}

