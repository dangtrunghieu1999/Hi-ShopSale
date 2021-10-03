//
//  SignUpViewModel.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 01/07/2021.
//

import UIKit

class SignUpViewModel: BaseViewModel {
    
    // MARK: - LifeCycles
    
    override func initialize() {}
    
    // MARK: - Public methods
    
    func canSignUp(email: String?,
                   phone: String?,
                   password: String?,
                   confirmPassword: String?) -> Bool {
        if ( email != nil && email != "" && email?.isValidEmail ?? false
                && phone?.isPhoneNumber != nil && phone != ""
                && password != nil && password != ""
                && confirmPassword != nil && confirmPassword != "") {
            return true
        } else {
            return false
        }
    }
    
    func isValidInfo(shopName: String?,
                     location: String?,
                     hotline: String?,
                     linkWeb: String?,
                     province: Province?,
                     district: District?,
                     ward: Ward?) -> Bool {
        if (shopName != nil && shopName != ""
                && location != nil && location != ""
                && hotline != nil && hotline != ""
                && linkWeb != nil && linkWeb != ""
                && province != nil
                && district != nil
                && ward != nil) {
            return true
        } else {
            return false
        }
    }
    
}
