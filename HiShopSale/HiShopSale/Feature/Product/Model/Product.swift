//
//  Product.swift
//  ZoZoApp
//
//  Created by MACOS on 6/29/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import SwiftyJSON

class Product: NSObject, JSONParsable, NSCopying{
    
    var id: Int?
    var name                 = ""
    var createdDate          = Date()
    var createdBy            = Date()
    var modifiedDate         = Date()
    var modifedBy            = Date()
    var price: Double        = 0.0
    var priceSale: Double    = 0.0
    var photos: [Photo]      = []
    var photo                = ""
    var descriptions         = ""
    var status               = 0
    var number_comment       = 0
    var comments: [Comment]  = []
    var shopId: Int?
    var shopName             = ""
    var shopAvatar           = ""
    var totalStar            = 0.0
    var sale                 = 0
    var categoryId           = 0
    var detail               = ""
    var productName: String  = ""
    var productPhoto: String = ""
    var json                 = JSON()
    var weight               = 0.0
    var avaiable             = 0
    var category             = Categories()
    var quantity             = 0
    var code                 = ""
    
    var defaultImage: String {
        return photos.first?.link ?? ""
    }
    
    var firstSubCategory: String {
        return category.subCategories.first?.name ?? ""
    }
    
    var discount: Int {
        return Int(price - priceSale / price) * 100
    }
    
    required override init() {}
    
    required init(json: JSON) {
        super.init()
        self.json = json
        id                  = json["id"].int
        name                = json["name"].stringValue
        photos              = json["photos"].arrayValue.map { Photo(json: $0) }
        comments            = json["comment"].arrayValue.map{ Comment(json: $0)}
        descriptions        = json["description"].stringValue
        price               = json["price"].doubleValue
        priceSale           = json["priceSale"].doubleValue
        totalStar           = json["totalStar"].doubleValue
        sale                = json["sale"].intValue
        number_comment      = json["number_comment"].intValue
        shopName            = json["shopName"].stringValue
        shopAvatar          = json["shopAvatar"].stringValue
        shopId              = json["shopId"].intValue
        photo               = json["photo"].stringValue
        detail              = json["detail"].stringValue
        productName         = json["productName"].stringValue
        productPhoto        = json["productPhoto"].stringValue
        quantity            = json["quantity"].intValue
        avaiable            = json["avaiable"].intValue
        weight              = json["weight"].doubleValue
        categoryId          = json["categoryId"].intValue
        code                = json["code"].stringValue
        category            = Categories(json: json["category"])
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Product(json: json)
        copy.name = name
        copy.priceSale = priceSale
        copy.price = price
        return copy
    }
}

// MARK: - Update

extension Product {
    
    func addNewPhoto(photos: [Photo]) {
        self.photos.append(contentsOf: photos)
    }
    
    func addNewPhoto(photo: Photo) {
        photos.append(photo)
    }
    
    func removePhoto(at index: Int) {
        if index < photos.count {
            photos.remove(at: index)
        }
    }
}

// MARK: - To Dict

extension Product {
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        if let id = id {
            dict["id"] = id.description
        }
        
        dict["name"]                = name
        dict["price"]               = price
        dict["priceSale"]           = priceSale
        dict["photos"]              = photos.map { $0.toDictionary() }
        dict["categoryId"]          = categoryId
        dict["weight"]              = weight
        dict["description"]         = descriptions
        dict["detail"]              = detail
        dict["avaiable"]            = avaiable
        return dict
    }
}

// MARK: - Product Detail Helper

extension Product {
    var numberCommentInProductDetail: Int {
        return commentInProductDetail.count
    }
    
    var commentInProductDetail: [Comment] {
        if comments.count >= 2 {
            return Array(comments.prefix(2))
        } else if let firstComment = comments.first, let firstChildComment = firstComment.commentChild.first {
            return [firstComment, firstChildComment]
        } else if let firstComment = comments.first {
            return [firstComment]
        } else {
            return []
        }
    }
}


// MARK: - Cart Helper

extension Product {
    var finalPrice: Double {
        if priceSale != 0 {
            return priceSale
        } else {
            return price
        }
    }
    
    var totalMoney: Double {
        return Double(quantity) * finalPrice
    }
}
