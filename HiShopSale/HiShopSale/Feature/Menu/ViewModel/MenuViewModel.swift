//
//  MenuViewModel.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 26/05/2021.
//

import UIKit

enum MenuType:Int {
    case home           = 1
    case product        = 2
    case plus           = 3
    case order          = 4
    case chat           = 5
    case statistics     = 6
    case notification   = 7
    case logout         = 8
    
    static func numberOfItems() -> Int {
        return 8
    }
    
}

class MenuViewModel: NSObject {
    
    var menuImage: [UIImage?] = [ImageManager.icon_home,
                                 ImageManager.icon_product,
                                 ImageManager.icon_plus,
                                 ImageManager.icon_order,
                                 ImageManager.icon_chat,
                                 ImageManager.icon_statistics,
                                 ImageManager.notification,
                                 ImageManager.icon_logout]
    
    var menuTitle: [String?]  = [TextManager.home,
                                 TextManager.product,
                                 TextManager.plus,
                                 TextManager.order,
                                 TextManager.changePW,
                                 TextManager.statistics,
                                 TextManager.notification,
                                 TextManager.logout]
}
