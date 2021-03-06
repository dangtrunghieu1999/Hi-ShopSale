//
//  Details.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 04/07/2021.
//

import UIKit
import SwiftyJSON

class Detail: NSObject, JSONParsable {
    
    var uuid: Int                  = 0
    var useTutorial: String?       = ""
    var category: String?          = ""
    var gurantee:Int               = 0
    var provide: String?           = ""
    var trademark: String?         = ""
    var brand: String?             = ""
    var material: String?          = ""
    var vat: String?               = ""
    var model: String?             = ""
    var madeBy: String?            = ""
    
    var dictValues: [Int: String?] = [:]
    var dictKeys: [Int: String]    = [:]
    
    required override init() {}
    
    required init(json: JSON) {
        super.init()
        self.uuid           = json["id"].intValue
        self.category       = json["category"].stringValue
        self.provide        = json["provideByShop"].stringValue
        self.trademark      = json["trademark"].stringValue
        self.brand          = json["brandOrigin"].stringValue
        self.useTutorial    = json["useTutorial"].stringValue
        self.madeBy         = json["madeBy"].stringValue
        self.material       = json["material"].stringValue
        self.model          = json["model"].stringValue
        self.vat            = json["vat"].stringValue
        self.gurantee       = json["gurantee"].intValue
        
        self.toObjectDictionary()
        self.toDictionKeyDetail()
    }
    
    func toObjectDictionary() {
        
        self.dictValues.updateValue(self.category, forKey: 0)
        self.dictValues.updateValue(self.provide, forKey: 1)
        self.dictValues.updateValue(self.trademark, forKey: 2)
        self.dictValues.updateValue(self.brand, forKey: 3)
        self.dictValues.updateValue(self.useTutorial, forKey: 4)
        self.dictValues.updateValue(self.madeBy, forKey: 5)
        self.dictValues.updateValue(self.material, forKey: 6)
        self.dictValues.updateValue(self.model, forKey: 7)
        self.dictValues.updateValue(self.vat, forKey: 8)
        self.dictValues.updateValue(self.gurantee.description, forKey: 9)
    }
    
    func toDictionKeyDetail() {
        
        self.dictKeys.updateValue("Danh m???c", forKey: 0)
        self.dictKeys.updateValue("Cung c???p b???i", forKey: 1)
        self.dictKeys.updateValue("Th????ng hi???u", forKey: 2)
        self.dictKeys.updateValue("Xu???t x??? th????ng hi???u", forKey: 3)
        self.dictKeys.updateValue("H?????ng d???n", forKey: 4)
        self.dictKeys.updateValue("Xu???t x???", forKey: 5)
        self.dictKeys.updateValue("Ch???t li???u", forKey: 6)
        self.dictKeys.updateValue("Model", forKey: 7)
        self.dictKeys.updateValue("Ho?? ????n VAT", forKey: 8)
        self.dictKeys.updateValue("B???o h??nh", forKey: 9)
    }
}
