//
//  CountryCollectionViewCell.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 16/09/2021.
//

import UIKit

class CountryCollectionViewCell: BaseCollectionViewCell {
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        return label
    }()
    
    private let lineView: BaseView = {
        let view = BaseView()
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    override func initialize() {
        super.initialize()
        layoutTitleLabel()
        layoutLineView()
    }
    
    func configCell(country: Country) {
        self.titleLabel.text = country.name + " " + country.flag
    }

    private func layoutTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY
                .equalToSuperview()
            make.left
                .equalToSuperview()
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutLineView() {
        addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left
                .equalTo(titleLabel)
            make.right
                .equalToSuperview()
            make.height
                .equalTo(1)
            make.bottom
                .equalToSuperview()
        }
        
    }
}
