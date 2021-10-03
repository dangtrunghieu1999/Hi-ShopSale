//
//  EnumProductDetail.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/13/21.
//

import UIKit

enum ProductDetailType: Int {
    case infomation
    case section1
    case advanedShop
    case section2
    case infoDetail
    case section3
    case description
    case section4
    case comment
    
    static func numberSection() -> Int {
        return 10
    }
    
    func sizeForHeader() -> CGSize {
        switch self {
        case .infoDetail, .description, .comment:
            return CGSize(width: ScreenSize.SCREEN_WIDTH, height: 50)
        default:
            return .zero
        }
    }
    
    var title: String {
        switch self {
        case .infoDetail:
            return TextManager.detailProduct
        case .description:
            return TextManager.detailDes
        case .comment:
            return TextManager.comment
        default:
            return ""
        }
    }
}
