//
//  AppRouter.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 27/05/2021.
//

import UIKit
import Photos

class AppRouter: NSObject {
    
    class func pushToVerifyOTPVC(with userName: String) {
        let viewController = VerifyOTPViewController()
        UIViewController.topNavigationVC?.pushViewController(viewController, animated: true)
    }
    
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
    
    class func presentPopupImage(urls: [String],
                                 selectedIndexPath: IndexPath = IndexPath(row: 0, section: 0),
                                 productName: String = "") {
        
        let storyboard = UIStoryboard(name: "PopUpSlideImage", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "PopUpSlideImageController") as? PopUpSlideImageController else {
            return
        }
        UIViewController.topViewController()?.present(viewController, animated: true, completion: nil)
        viewController.setupData(selectedIndexPath: selectedIndexPath, urls: urls, productName: productName)
    }
    
    class func pushToAvatarCropperVC(image: UIImage,
                                     completion: @escaping ImageCropperCompletion,
                                     dismis: @escaping ImageCropperDismiss) {
        let config = ImageCropperConfiguration(with: image, and: .circle)
        let viewController = ImageCropperViewController.initialize(with: config,
                                                                   completionHandler: completion,
                                                                   dismiss: dismis)
        UIViewController.topNavigationVC?.pushViewController(viewController, animated: true)
    }
    
    class func presentViewParameterProduct(viewController: UIViewController, detail: String, id: Int){
        
        let vc = ParameterViewController()
        vc.configCell(detail: detail,id: id)
        let nvc = UINavigationController(rootViewController: vc)
        viewController.present(nvc, animated: true, completion: nil)
    }
    
    class func pushToOrderDetailVC(id: Int, viewController: BaseViewController) {
        let viewController = OrderDetailViewController()
        viewController.requestAPIOrderDetail(orderId: id)
        UINavigationController.topNavigationVC?.pushViewController(viewController, animated: true)
    }
    
}
