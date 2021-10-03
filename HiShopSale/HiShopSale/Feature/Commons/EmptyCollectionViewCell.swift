//
//  EmptyCollectionViewCell.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 13/06/2021.
//

import UIKit

class EmptyCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables
    
    var message: String? {
        didSet {
            emptyView.message = message
        }
    }
    
    var image: UIImage? {
        didSet {
            emptyView.image = image
        }
    }
    
    var imageSize: CGSize = CGSize(width: 90, height: 90) {
        didSet {
            emptyView.updateImageSize(imageSize)
        }
    }
    
    var messageFont: UIFont = UIFont.systemFont(ofSize: FontSize.body.rawValue) {
        didSet {
            emptyView.font = messageFont
        }
    }
    
    // MARK: - UI Elements
    
    let emptyView = EmptyView()
    
    // MARK: - LifeCycles
    
    override func initialize() {
        layoutEmptyView()
    }
    
    // MARK: - Layout
    
    private func layoutEmptyView() {
        addSubview(emptyView)
        emptyView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}
