//
//  UserManager.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 21/05/2021.
//

import UIKit
import KeychainAccess

struct KeychainKey {
    static let AccessToken      = "vn.zozoapp.accessToken"
    static let FCMToken         = "vn.zozoapp.fcmToken"
    static let Password         = "vn.zozoapp.password"
    static let UserId           = "vn.zozoapp.userId"
    static let UserObject       = "vn.zozoapp.userObject"
    static let ShopCode         = "vn.zozoapp.shopCode"
}

let UserManager = UserSessionManager.shared

class UserSessionManager: NSObject {
    
    static let shared = UserSessionManager()
    
    private var currentUser: User?
    private let keychain = Keychain(service: AppInfo.bundleId())
    
    // MARK: - Methods
    
    func isLoggedIn() -> Bool {
        return self.loadLoggedInUser() != nil
    }
    
    func  saveFCMToken(_ token: String) {
        keychain[KeychainKey.FCMToken] = token
    }
    
    func saveToken(_ token: String) {
        keychain[KeychainKey.AccessToken] = token
    }
    
    func saveUserId(_ userId: String) {
        keychain[KeychainKey.UserId] = "\(userId)"
    }
     
    func saveCode(_ code: String) {
        keychain[KeychainKey.ShopCode] = code
    }
    
    func loadLoggedInUser() -> User? {
        if let data = UserDefaults.standard.object(forKey: KeychainKey.UserObject) as? Data {
            NSKeyedUnarchiver.setClass(User.self, forClassName: "User")
            if let savedUser = NSKeyedUnarchiver.unarchiveObject(with: data) as? User {
                savedUser.token = self.accessToken ?? ""
                savedUser.id = self.userId ?? ""
                return savedUser
            }
            return nil
        }
        return nil
    }
    
    func saveCurrentUser(_ user: User) {
        user.id = "\(user.id)"
        saveToken(user.token)
        saveUserId(user.id)
        saveCode(user.code)
        let saveUser = user
        saveUser.token = ""
        saveUser.id = ""
        let encodedUser = NSKeyedArchiver.archivedData(withRootObject: user)
        UserDefaults.standard.set(encodedUser, forKey: KeychainKey.UserObject)
        UserDefaults.standard.synchronize()
    }
    
    func removeCurrentUser() {
        UserDefaults.standard.removeObject(forKey: KeychainKey.UserObject)
        UserDefaults.standard.synchronize()
    }
    
    func logout() {
        do {
            currentUser = nil
            removeCurrentUser()
            try keychain.remove(KeychainKey.AccessToken)
            try keychain.remove(KeychainKey.UserId)
        } catch {
            print("UserSession > logout > remove keychain error")
        }
        
        UserDefaults.standard.removeObject(forKey: KeychainKey.UserObject)
        UserDefaults.standard.synchronize()
    }
    
    // MARK: - Get data
    
    var userId: String? {
        return keychain[KeychainKey.UserId]
    }
    
    var accessToken: String? {
        return keychain[KeychainKey.AccessToken]
    }
    
    var user: User? {
        if self.currentUser == nil {
            return self.loadLoggedInUser()
        } else {
            return currentUser
        }
    }
    
    var fcmToken: String? {
        return keychain[KeychainKey.FCMToken]
    }
    
    var code: String? {
        return keychain[KeychainKey.ShopCode]
    }
    
}

// MARK: - API Request

extension UserSessionManager {
    func getUserProfile() {
        guard let userId = userId else { return }
        guard let code   = code else { return }
        let endPoint = UserShopEndPoint.getShopInfo
        
        APIService.request(endPoint: endPoint, onSuccess: { (apiResponse) in
            guard let userProfile = apiResponse.toObject(User.self) else { return }
            userProfile.token = self.accessToken ?? ""
            userProfile.id = userId
            userProfile.code = code
            self.currentUser = userProfile
            self.saveCurrentUser(userProfile)
            self.postFCMTokenAPI()
        }, onFailure: { (apiError) in
            
        }) {
            
        }
    }
    
    func postFCMTokenAPI() {
        guard let fcmToken = self.fcmToken else { return }
        
        let endPoint = UserShopEndPoint.postFCMToken(params: ["FCMToken": fcmToken])
        
        APIService.request(endPoint: endPoint) { apiResponse in
            
        } onFailure: { error in
            
        } onRequestFail: {
            
        }
    }
}
