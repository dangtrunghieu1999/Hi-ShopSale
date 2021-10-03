//
//  LoadMoreCollectionViewCell.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 13/06/2021.
//

import UIKit

class LoadMoreCollectionViewCell: BaseCollectionViewHeaderFooterCell {
    private let indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.color = UIColor.primary
        return indicatorView
    }()
    
    override func initialize() {
        setupViewIndicatorView()
    }
    
    func animiate(_ value: Bool) {
        if value {
            indicatorView.startAnimating()
            indicatorView.isHidden = false
        } else {
            indicatorView.stopAnimating()
            indicatorView.isHidden = true
        }
    }
    
    private func setupViewIndicatorView() {
        addSubview(indicatorView)
        indicatorView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
}
