//
//  Category.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 03/07/2021.
//

import SwiftyJSON

class Categories: NSObject, JSONParsable {
        
    var uuid:  Int?              = 0
    var name:  String?           = ""
    var image: String?           = ""
    var parentId: Int?           = 0
    var subCategories: [Categories]     = []
    
    required override init() {}
    required init(json: JSON) {
        
        self.uuid           = json["id"].intValue
        self.name           = json["name"].stringValue
        self.image          = json["image"].stringValue
        self.subCategories  = json["subCategories"].arrayValue.map {Categories(json: $0)}
    }
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        dict["id"]          = uuid
        
        return dict
    }

}
