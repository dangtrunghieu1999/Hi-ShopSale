//
//  Delivery.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 01/07/2021.
//

import UIKit
import SwiftyJSON

class AddressShop: NSObject, NSCoding, JSONParsable {
    
    var id: Int         = 0
    var name            = ""
    var phone           = ""
    var location        = ""
    var province        : Province?
    var district        : District?
    var ward            : Ward?
    var infoUser        = ""
    var addressDetail   = ""
    
    var isValidInfo: Bool {
        if name != ""
            && phone != "" && phone.isPhoneNumber
            && location != ""
            && province != nil
            && district != nil
            && ward != nil
        {
            return true
        } else {
            return false
        }
    }
    
    required override init() {
        super.init()
    }
    
    required init(json: JSON) {
        self.id            = json["id"].intValue
        self.name          = json["name"].stringValue
        self.phone         = json["phone"].stringValue
        self.location      = json["location"].stringValue
        self.ward          = Ward(json: json["wards"])
        self.province      = Province(json: json["province"])
        self.district      = District(json: json["district"])
        self.infoUser      = name + " - " + phone
        self.addressDetail = "\(location), \(ward?.name ?? ""), \(district?.name ?? ""), \(province?.name ?? "")"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(location, forKey: "location")
        aCoder.encode(province, forKey: "province")
        aCoder.encode(district, forKey: "district")
        aCoder.encode(ward, forKey: "ward")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name            = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        phone           = aDecoder.decodeObject(forKey: "phone") as? String ?? ""
        location        = aDecoder.decodeObject(forKey: "location") as? String ?? ""
        province        = aDecoder.decodeObject(forKey: "province") as? Province
        district        = aDecoder.decodeObject(forKey: "district") as? District
        ward            = aDecoder.decodeObject(forKey: "ward") as? Ward
    }
    
    func setLocationFinishSelect(_ deliveryInfo: AddressShop) {
        self.province = deliveryInfo.province
        self.district = deliveryInfo.district
        self.ward     = deliveryInfo.ward
    }
    
    func setAddressDelivery(_ info: String,_ address: String) {
        self.infoUser       = info
        self.addressDetail  = address
    }
}

