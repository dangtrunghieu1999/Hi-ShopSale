//
//  FirebaseDataBase.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 22/08/2021.
//

import Foundation
import Firebase
import FirebaseDatabase


/*
 case all         = 0
 case process     = 1
 case transport   = 2
 case success     = 3
 case canccel     = 4
 */

class FirebaseDataBase {
    
    static var shared = FirebaseDataBase()
    
    private var ref: DatabaseReference
    
    init() {
        ref = Database.database().reference()
    }
    
    // Buyer
    func observerOrderStatusChange(for userId: String, newOrderHandler: @escaping (String, OrderStatus) -> Void) {
        var didFirstLoad = false

        self.ref.child("orders").child(userId).observe(.childAdded) { data in
            if didFirstLoad {
                guard let values = data.value as? [String: Any] else {
                    return
                }
                
                guard let code    = values["code"] as? String,
                      let status  = values["status"] as? Int
                else {
                    return
                }
                let orderStatus = OrderStatus(rawValue: status) ?? .canccel

                newOrderHandler(code, orderStatus)
            }
        }
        
        self.ref.child("orders").child(userId).observe(.childChanged) { data in
    
            guard let values = data.value as? [String: Any] else {
                return
            }
            
            guard let code    = values["code"] as? String,
                  let status  = values["status"] as? Int
            else {
                return
            }
            let orderStatus = OrderStatus(rawValue: status) ?? .canccel

            newOrderHandler(code, orderStatus)
            didFirstLoad = true
        }
    }
    
    func observerCommentChange(for userId: String, commentChangeHandler: @escaping (String) -> Void) {
        var didFirstLoad = false
        self.ref.child("comments").child(userId).observe(.childChanged) { data in
            let productId = data.key
            commentChangeHandler(productId)
            didFirstLoad = true
        }
        
        self.ref.child("comments").child(userId).observe(.childAdded) { data in
            if didFirstLoad {
                let productId = data.key
                commentChangeHandler(productId)
            }
        }
    }
    
}
