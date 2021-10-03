//
//  EmptyTableViewCell.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 22/08/2021.
//

import UIKit

class EmptyTableViewCell: BaseTableViewCell {

    // MARK: - Variables
    
    var message: String? {
        didSet {
            emptyView.message = message
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
            make.left.right.bottom.top.equalToSuperview()
        }
    }

}
