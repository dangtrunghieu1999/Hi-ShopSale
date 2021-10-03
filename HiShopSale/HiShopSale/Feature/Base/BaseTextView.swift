//
//  BaseViewAddress.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 22/05/2021.
//

import UIKit

class BaseTextView: BaseView {
    
    var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    var boderColor: UIColor? {
        didSet {
            addressTextView.layer.borderColor = boderColor?.cgColor
            addressTextView.layer.borderWidth = 1
        }
    }
    
    var placeholder: String? {
        didSet {
            addressTextView.text = placeholder
        }
    }
    
    var content: String? {
        didSet {
            addressTextView.text = content
        }
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .semibold)
        return label
    }()
    
    lazy var addressTextView: UITextView = {
        let textView = UITextView()
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 20)
        textView.text = TextManager.shopAddress.localized()
        textView.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        textView.textColor = UIColor.placeholder
        textView.layer.borderColor = UIColor.separator.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = dimension.cornerRadiusSmall
        textView.layer.masksToBounds = true
        textView.delegate = self
        return textView
    }()
    
    override func initialize() {
        super.initialize()
        layoutAddressTitleLabel()
        layoutAddressTextView()
    }
    
    private func layoutAddressTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
        }
    }
    
    private func layoutAddressTextView() {
        addSubview(addressTextView)
        addressTextView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
                .offset(Dimension.shared.mediumMargin)
            make.height.equalTo(50)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - UITextViewDelegate

extension BaseTextView: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == TextManager.shopAddress.localized() {
            textView.text = ""
        }
        textView.textColor = UIColor.titleText
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = TextManager.shopAddress.localized()
            textView.textColor = UIColor.placeholder
        }
    }
}
