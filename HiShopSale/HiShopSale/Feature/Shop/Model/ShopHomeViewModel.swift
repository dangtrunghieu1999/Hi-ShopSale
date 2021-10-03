//
//  ShopHomeViewModel.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 28/06/2021.
//

import UIKit

class ShopHomeViewModel: BaseViewModel {
    // MARK: - LifeCycles
    override func initialize() {}
    
    // MARK: - Request APIs
    
    func uploadImage(image: UIImage, completion: @escaping (URL) -> Void, error: @escaping () -> Void) {
        let id = UUID().uuidString + ".jpg"
        
        guard  let base64Image = image.base64ImageString else {
            return
        }
        let param = ["base64String": base64Image,
                     "name": id]
        let endpoint = CommonEndPoint.uploadPhoto(params: param)
        APIService.request(endPoint: endpoint, onSuccess: { (apiResponse) in
            
            guard let path = apiResponse.data?["url"].stringValue else {
                error()
                return
            }
            guard let url = path.addImageDomainIfNeeded().url else {
                error()
                return
            }
            completion(url)
        }, onFailure: { (apiServiceError) in
            error()
        }) {
            error()
        }
    }
    
    func updateShopInfo(params: [String: Any], completion: @escaping () -> Void, error: @escaping () -> Void) {
        let endPoint = ShopEndPoint.updateShopInfo(params: params)
        APIService.request(endPoint: endPoint, onSuccess: { (apiResponse) in
            completion()
        }, onFailure: { (apiError) in
            error()
        }) {
            error()
        }
    }
    
}
