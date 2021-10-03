//
//  ProductEndPoint.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 13/06/2021.
//

import Foundation
import Alamofire


enum ProductEndPoint {
    case getAllProduct
    case savePhotos(params: Parameters)
    case getProductById(parameters: Parameters)
    case createComment(parameters: Parameters)
    case getAllOrder
    case getOrderDetail(params: Parameters)
    case createProduct(params: Parameters)
    case updateProduct(params: Parameters)
    case updateDetail(params: Parameters)
    case getCommentProduct(params: Parameters)
    case updateStatus(params: Parameters)
    case cancelOrder(params: Parameters)
}

extension ProductEndPoint: EndPointType {
    
    var path: String {
        switch self {
        case .getAllProduct:
            return "/shop/product"
        case .savePhotos:
            return "/shop/photo"
        case .getProductById:
            return "/product"
        case .createComment:
            return "/product/comment"
        case .getAllOrder:
            return "/shop/order/list"
        case .getOrderDetail:
            return "/shop/order"
        case .createProduct:
            return "/product"
        case .updateProduct:
            return "/product/infor"
        case .updateDetail:
            return "/product/detail"
        case .getCommentProduct:
            return "/product/comment"
        case .updateStatus:
            return "/shop/order/tranport"
        case .cancelOrder:
            return "/shop/order/cancel"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getAllProduct:
            return .get
        case .savePhotos:
            return .put
        case .getProductById:
            return .get
        case .createComment:
            return .post
        case .getAllOrder:
            return .get
        case .getOrderDetail:
            return .get
        case .createProduct:
            return .post
        case .updateProduct:
            return .put
        case .updateDetail:
            return .put
        case .getCommentProduct:
            return .get
        case .updateStatus:
            return .put
        case .cancelOrder:
            return .put
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getProductById(let parameters):
            return parameters
        case .getAllProduct:
            return nil
        case .savePhotos(let params):
            return params
        case .createComment(let parameters):
            return parameters
        case .getAllOrder:
            return nil
        case .getOrderDetail(let params):
            return params
        case .createProduct(let params):
            return params
        case .updateProduct(let params):
            return params
        case .updateDetail(let params):
            return params
        case .getCommentProduct(let params):
            return params
        case .updateStatus(let params):
            return params
        case .cancelOrder(let params):
            return params
        }
    }
}
