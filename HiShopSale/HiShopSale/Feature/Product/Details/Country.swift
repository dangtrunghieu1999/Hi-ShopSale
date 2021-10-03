//
//  Contry.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 16/09/2021.
//

import Foundation
import SwiftyJSON

class Country: NSObject, JSONParsable {
    
    var name: String = ""
    var code: String = ""
    var flag: String = ""
    
    required override init() {}
    
    required init(json: JSON) {
        self.name = json["name"].stringValue
        self.code = json["code"].stringValue
        self.flag = json["flag"].stringValue
    }
    
}
