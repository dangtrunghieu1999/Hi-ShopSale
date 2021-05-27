//
//  AppRouter.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 27/05/2021.
//

import UIKit
import Photos

class AppRouter: NSObject {
    
    
    class func presentToImagePicker(pickerDelegate: ImagePickerControllerDelegate?,
                                    limitImage: Int = 1,
                                    selecedAssets: [PHAsset] = []) {
        var parameters = ImagePickerParameters()
        parameters.navigationBarTintColor = UIColor.white
        parameters.navigationBarTitleTintColor = UIColor.white
        parameters.photoAlbumsNavigationBarShadowColor = UIColor.clear
        parameters.allowedSelections = .limit(to: limitImage)
        let viewController = ImagePickerController.init(selectedAssets: selecedAssets, configuration: parameters)
        viewController.delegate = pickerDelegate
        UIViewController.topViewController()?.present(viewController, animated: true, completion: nil)
    }
    
    
}
