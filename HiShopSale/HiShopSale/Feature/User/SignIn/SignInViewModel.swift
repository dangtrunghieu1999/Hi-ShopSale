//
//  SignInViewModel.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 15/06/2021.
//

import UIKit

class SignInViewModel: BaseViewModel {
    
    func requestSignIn(userName: String,
                       passWord: String,
                       onSuccess: @escaping (User?) -> Void,
                       onError: @escaping (String) -> Void) {
        
        let params = ["username": userName, "password": passWord]
        let endPoint = UserShopEndPoint.signIn(params: params)
        
        APIService.request(endPoint: endPoint, onSuccess: { (apiResponse) in
            guard apiResponse.data != nil else {
                onError(TextManager.accNotActive.localized())
                return
            }
            
            if let user = apiResponse.toObject(User.self) {
                UserManager.saveCurrentUser(user)
                UserManager.getUserProfile()
                
                onSuccess(user)
            } else {
                onError(TextManager.loginFailMessage.localized())
            }
            
        }, onFailure: { (serviceError) in
            if serviceError?.message == "Account is inactive!" {
                if userName.isPhoneNumber {
                    
                } else {
                    onError(TextManager.accNotActive.localized())
                }
            } else {
                onError(TextManager.loginFailMessage.localized())
            }
            
        }) {
            onError(TextManager.errorMessage.localized())
        }
    }
    
}
