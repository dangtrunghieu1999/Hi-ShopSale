//
//  OrderCancelCollectionViewCell.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 22/09/2021.
//

import UIKit

protocol OrderCancelCollectionViewCellDelegate: AnyObject {
    func handleOrderCancel()
}

class OrderCancelCollectionViewCell: BaseCollectionViewCell {
    
    weak var delegate: OrderCancelCollectionViewCellDelegate?
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.cancel, for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.primary.cgColor
        button.setTitleColor(UIColor.primary, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        button.addTarget(self, action: #selector(tapOnCancel),
                         for: .touchUpInside)
        return button
    }()
    
    override func initialize() {
        super.initialize()
        layoutCancelButton()
    }
    
    @objc func tapOnCancel() {
        self.delegate?.handleOrderCancel()
    }
    
   private func layoutCancelButton() {
        addSubview(self.cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(dimension.normalMargin)
            make.height.equalTo(dimension.defaultHeightButton)
        }
    }
}
