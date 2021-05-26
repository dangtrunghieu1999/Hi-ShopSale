//
//  MenuViewModel.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 26/05/2021.
//

import UIKit

enum MenuType:Int {
    case home       = 1
    case product    = 2
    case store      = 3
    case plus       = 4
    case order      = 5
    case chat       = 6
    case statistics = 7
    case logout     = 8
    
    static func numberOfItems() -> Int {
        return 8
    }
    
}

class MenuViewModel: NSObject {
    
    var menuImage: [UIImage?] = [ImageManager.icon_home,
                                 ImageManager.icon_product,
                                 ImageManager.icon_store,
                                 ImageManager.icon_plus,
                                 ImageManager.icon_order,
                                 ImageManager.icon_chat,
                                 ImageManager.icon_statistics,
                                 ImageManager.icon_logout]
    
    var menuTitle: [String?]  = [TextManager.home,
                                 TextManager.product,
                                 TextManager.store,
                                 TextManager.plus,
                                 TextManager.order,
                                 TextManager.chat,
                                 TextManager.statistics,
                                 TextManager.logout]
}
