//
//  CommonEndPoint.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 28/06/2021.
//

import Alamofire
import UIKit

enum CommonEndPoint {
    case uploadPhoto(params: Parameters)
}

extension CommonEndPoint: EndPointType {
    
    var path: String {
        switch self {
        case .uploadPhoto:
            return "/shop/avatar"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .uploadPhoto:
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .uploadPhoto(let params):
            return params
        }
    }
}
