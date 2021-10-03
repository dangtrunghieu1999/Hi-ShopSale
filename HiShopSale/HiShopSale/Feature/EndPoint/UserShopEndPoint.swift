//
//  UserShopEndPoint.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 13/06/2021.
//

import Foundation
import Alamofire


enum UserShopEndPoint {
    case signIn(params: Parameters)
    case signUp(params: Parameters)
    case getShopInfo
    case saveAvatar(params: Parameters)
    case forgotPW(params: Parameters)
    case verifyOTP(params: Parameters)
    case checkOTP(params: Parameters)
    case resendOTP(params: Parameters)
    case updateInfoUser(params: Parameters)
    case updateAddress(params: Parameters)
    case getNotifications(params: Parameters)
    case postFCMToken(params: Parameters)
    case changePW(params: Parameters)
    case getStatistical(params: Parameters)
    case sendFileExecel(params: Parameters)
}

extension UserShopEndPoint: EndPointType {
    
    var path: String {
        switch self {
        case .signIn:
            return "/shop/login"
        case .signUp:
            return "/shop/register"
        case .getShopInfo:
            return "/shop/me"
        case .saveAvatar:
            return "/shop/avatar"
        case .forgotPW:
            return "/shop/forgotpassword"
        case .verifyOTP:
            return "/shop/verify"
        case .resendOTP:
            return "/shop/sendotp"
        case .updateInfoUser:
            return "/shop"
        case .updateAddress:
            return "/shop/detail"
        case .getNotifications:
            return "/shop/notification"
        case .postFCMToken:
            return "/shop/fcmtoken"
        case .changePW:
            return "/shop/changepassword"
        case .getStatistical:
            return "/shop/statistical"
        case .checkOTP:
            return "/shop/checkotp"
        case .sendFileExecel:
            return "/shop/statistical/export"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .signIn:
            return .post
        case .signUp:
            return .post
        case .getShopInfo:
            return .get
        case .saveAvatar:
            return .post
        case .forgotPW:
            return .put
        case .verifyOTP:
            return .post
        case .resendOTP:
            return .post
        case .updateInfoUser:
            return .put
        case .updateAddress:
            return .put
        case .getNotifications:
            return .get
        case .postFCMToken:
            return .post
        case .changePW:
            return .put
        case .getStatistical:
            return .get
        case .checkOTP:
            return .post
        case .sendFileExecel:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .signIn(let params):
            return params
        case .signUp(let params):
            return params
        case .getShopInfo:
            return nil
        case .saveAvatar(let params):
            return params
        case .forgotPW(let params):
            return params
        case .verifyOTP(let params):
            return params
        case .resendOTP(let params):
            return params
        case .updateInfoUser(let params):
            return params
        case .updateAddress(let params):
            return params
        case .getNotifications(let params):
            return params
        case .postFCMToken(let params):
            return params
        case .changePW(let params):
            return params
        case .getStatistical(let params):
            return params
        case .checkOTP(let params):
            return params
        case .sendFileExecel(let params):
            return params
        }
    }
}
