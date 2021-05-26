//
//  MenuViewModel.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 26/05/2021.
//

import UIKit

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
