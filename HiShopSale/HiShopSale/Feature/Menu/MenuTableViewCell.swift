//
//  MenuTableViewCell.swift
//  HiShopSale
//
//  Created by Dang Trung Hieu on 5/12/21.
//

import UIKit

class MenuTableViewCell: BaseTableViewCell {
    
    // MARK: - UI Elements
    
    fileprivate lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    fileprivate lazy var titleNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutAvatarImageView()
        layoutTitleNameLabel()
        layoutLineView()
    }
    
    func configData(image: UIImage?, title: String?) {
        self.avatarImageView.image = image
        self.titleNameLabel.text   = title
    }
    
    // MARK: - Setup layouts
    
    private func layoutAvatarImageView() {
        addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(25)
            make.left.equalToSuperview()
                .offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutTitleNameLabel() {
        addSubview(titleNameLabel)
        titleNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImageView.snp.right)
                .offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview()
                .offset(-Dimension.shared.largeMargin)
            make.centerY.equalToSuperview()
        }
    }
    
    private func layoutLineView() {
        addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
