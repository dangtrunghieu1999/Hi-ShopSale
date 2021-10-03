//
//  ShopEndPoint.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 13/06/2021.
//

import Foundation
import Alamofire


enum ShopEndPoint {
    case updateShopInfo(params: Parameters)
    case getAllProductById(params: Parameters)
    case deleteProductById(params: Parameters)
}

extension ShopEndPoint: EndPointType {
    
    var path: String {
        switch self {
        case .updateShopInfo:
            return ""
        case .getAllProductById:
            return "/shop/product"
        case .deleteProductById:
            return "/product"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .updateShopInfo:
            return .post
        case .getAllProductById:
            return .get
        case .deleteProductById:
            return .delete
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getAllProductById(let params):
            return params
        case .updateShopInfo(let params):
            return params
        case .deleteProductById(let params):
            return params
        }
    }
}
