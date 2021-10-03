//
//  User.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 22/05/2021.
//

import UIKit
import SwiftyJSON
import Alamofire

class User: NSObject, JSONParsable, NSCoding {
    
    var id                    = ""
    var code                  = ""
    var token                 = ""
    var avatar                = ""
    var name                  = ""
    var email                 = ""
    var userName              = ""
    var phone                 = ""
    var hotLine               = ""
    var website               = ""
    var location              = ""
    var addressId             = ""
    var province: Province    = Province()
    var district: District    = District()
    var ward: Ward            = Ward()
    
    var addressShop: String {
        return "\(location), \(ward.name), \(district.name), \(ward.name)"
    }
    required override init() {}

    required init(json: JSON) {
        self.id             = json["id"].stringValue
        self.token          = json["token"].stringValue
        self.code           = json["code"].stringValue
        self.name           = json["name"].stringValue
        self.avatar         = json["avatar"].stringValue
        self.email          = json["email"].stringValue
        self.userName       = json["userName"].stringValue
        self.phone          = json["phone"].stringValue
        self.location       = json["location"].stringValue
        self.website        = json["website"].stringValue
        self.hotLine        = json["hotLine"].stringValue
        self.addressId      = json["addressId"].stringValue
        self.province       = Province(json: json["province"])
        self.district       = District(json: json["district"])
        self.ward           = Ward(json: json["wards"])
    }
    
    required init?(coder aDecoder: NSCoder) {
        id          = aDecoder.decodeObject(forKey: "id") as? String ?? ""
        token       = aDecoder.decodeObject(forKey: "token") as? String ?? ""
        code        = aDecoder.decodeObject(forKey: "code") as? String ?? ""
        avatar      = aDecoder.decodeObject(forKey: "avatar") as? String ?? ""
        email       = aDecoder.decodeObject(forKey: "email") as? String ?? ""
        addressId   = aDecoder.decodeObject(forKey: "addressId") as? String ?? ""
        name        = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        userName    = aDecoder.decodeObject(forKey: "userName") as? String ?? ""
        phone       = aDecoder.decodeObject(forKey: "phone") as? String ?? ""
        hotLine     = aDecoder.decodeObject(forKey: "hotLine") as? String ?? ""
        website     = aDecoder.decodeObject(forKey: "website") as? String ?? ""
        location    = aDecoder.decodeObject(forKey: "location") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id,           forKey: "id")
        aCoder.encode(token,        forKey: "token")
        aCoder.encode(code,         forKey: "code")
        aCoder.encode(name,         forKey: "name")
        aCoder.encode(avatar,       forKey: "avatar")
        aCoder.encode(email,        forKey: "email")
        aCoder.encode(userName,     forKey: "userName")
        aCoder.encode(phone,        forKey: "phone")
        aCoder.encode(addressId,    forKey: "addressId")
        aCoder.encode(hotLine,      forKey: "hotLine")
        aCoder.encode(website,      forKey: "website")
        aCoder.encode(location,     forKey: "location")
        aCoder.encode(addressShop,  forKey: "addressShop")
        aCoder.encode(province,     forKey: "province")
        aCoder.encode(district,     forKey: "district")
        aCoder.encode(ward,         forKey:  "wards")
    }
    
    func toDictionary() -> [String: Any] {
        let params: Parameters = ["id":         self.id,
                                  "email":      self.email,
                                  "name":       self.name,
                                  "phone":      self.phone,
                                  "location":   self.location,
                                  "hotLine":    self.hotLine,
                                  "website":    self.website,
                                  "province":   self.province.toDictionary() ,
                                  "district":   self.district.toDictionary(),
                                  "wards":      self.ward.toDictionary()]
        return params
    }
    
}
