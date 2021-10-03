//
//  ShopHomeProductListSearchHeaderView.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 13/06/2021.
//

import UIKit
protocol ShopSearchViewDelegate: AnyObject {
    func didEndSearch()
    func didSearch(text: String?)
}

class ShopHomeProductListSearchHeaderView: BaseCollectionViewHeaderFooterCell {
    // MARK: - Variables
    weak var delegate: ShopSearchViewDelegate?
    private let buttonHorizontalMargin: CGFloat = 4
    private let textFieldHeight: CGFloat        = 36
    private let buttonWidth: CGFloat            = 120
    
    // MARK: - UI Elements
    
    lazy var searchTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.placeholder = TextManager.searchProduct.localized()
        textField.leftImage = ImageManager.searchGray
        textField.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1.0
        textField.returnKeyType = .search
        textField.clearButtonMode = .whileEditing
        textField.layer.borderColor = UIColor.lightSeparator.cgColor
        textField.addTarget(self, action: #selector(textFieldValueChange), for: .editingChanged)
        textField.addTarget(self, action: #selector(textFieldEndEditing), for: .editingDidEnd)
        textField.delegate = self
        return textField
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightBackground
        return view
    }()
    
    // MARK: - LifeCycles
    
    override func initialize() {
        backgroundColor = UIColor.white
        layoutSearchBar()
        layoutSeparatorView()
    }
    
    
    // MARK: - UIActions
    
    @objc func textFieldValueChange() {
        self.delegate?.didSearch(text: searchTextField.text)
    }
    
    @objc func textFieldEndEditing() {
        if searchTextField.text == "" || searchTextField.text == nil {
            self.delegate?.didEndSearch()
        }
    }
    
    // MARK: - Layouts
    
    private func layoutSearchBar() {
        addSubview(searchTextField)
        searchTextField.snp.makeConstraints { (make) in
            make.height.equalTo(textFieldHeight)
            make.top.equalToSuperview().offset(16)
            make.left
                .right
                .equalToSuperview()
                .inset(dimension.mediumMargin)
        }
    }
    
    private func layoutSeparatorView() {
        addSubview(separatorView)
        separatorView.snp.makeConstraints { (make) in
            make.width
                .bottom
                .centerX
                .equalToSuperview()
            make.height.equalTo(6)
        }
    }
}

// MARK: - UITextFieldDelegate

extension ShopHomeProductListSearchHeaderView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
}
