//
//  Photo.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 26/05/2021.
//

import UIKit
import SwiftyJSON

class Photo: NSObject, JSONParsable {
    
    var base64String: String?
    var name = ""
    var link = ""
    
    // Local data
    var currentImage: UIImage?
    
    required override init() {}
    
    init(image: UIImage?) {
        currentImage = image
    }
    
    required init(json: JSON) {
        base64String    = json["base64String"].string
        name            = json["name"].stringValue
        link            = json["link"].stringValue
    }
    
}

// MARK: - Map to Dictionary

extension Photo {
    func toDictionary() -> [String: Any] {
        
        if currentImage != nil {
            return toUpdateDictionary()
        }
        
        var dict: [String: Any] = [:]
        
        if let image = currentImage {
            dict["base64String"] = image.base64ImageString ?? ""
        }
        dict["link"] = link
        dict["name"] = name
        return dict
    }
    
    func toUpdateDictionary() -> [String: Any] {
        var params: [String: Any] = [:]
        let id = UUID().uuidString
        params["name"]          = id + ".jpg"
        params["base64String"]  = currentImage?.base64ImageString ?? ""
        return params
    }
}
