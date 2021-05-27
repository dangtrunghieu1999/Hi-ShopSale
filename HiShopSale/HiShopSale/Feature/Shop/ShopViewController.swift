//
//  ShopViewController.swift
//  HiShopSale
//
//  Created by Dang Trung Hieu on 5/12/21.
//

import UIKit
import RxSwift
import RxCocoa

class ShopViewController: BaseViewController {

    // MARK: - Variables
    lazy var editBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: TextManager.edit,
                                            style: .done,
                                            target: self,
                                            action: nil)
        let attributedText  = [NSAttributedString.Key.font:
                                UIFont.systemFont(ofSize: FontSize.h1.rawValue),
                               NSAttributedString.Key.foregroundColor: UIColor.black]
        barButtonItem.setTitleTextAttributes(attributedText, for: .normal)
        return barButtonItem
    }()

    // MARK: - UI Elements
    
    let contenStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = dimension.largeMargin
        return stackView
    }()
    
    let avatarView = UIView()
        
    fileprivate lazy var changePhotoButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.changePhoto, for: .normal)
        button.setTitleColor(UIColor.second, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .semibold)
        return button
    }()
    
    fileprivate lazy var shopNameTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText   = TextManager.shopName.localized()
        textField.textField.fontSizePlaceholder(text: TextManager.shopNamePlaceholder.localized(),
                                                size: FontSize.h1.rawValue)
        textField.text = "Routine"
        textField.boderColor = UIColor.second
        return textField
    }()
    
    fileprivate lazy var shopPhoneTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText   = TextManager.shopPhone.localized()
        textField.textField.fontSizePlaceholder(text: TextManager.shopNamePlaceholder.localized(),
                                                size: FontSize.h1.rawValue)
        textField.text = "0336665653"
        textField.boderColor = UIColor.second
        textField.keyboardType = .numberPad
        return textField
    }()

    fileprivate lazy var shopAddressTextView: BaseTextView = {
        let textview = BaseTextView()
        textview.titleText   = TextManager.shopAddressTitle
        textview.placeholder = TextManager.shopAddress
        textview.boderColor  = UIColor.second
        return textview
    }()
    
    fileprivate lazy var shopHotlineTextFields: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText   = TextManager.hotline.localized()
        textField.textField.fontSizePlaceholder(text: TextManager.hotlinePlaceholder.localized(),
                                                size: FontSize.h1.rawValue)
        textField.text = "19002345"
        textField.boderColor = UIColor.second
        textField.keyboardType = .numberPad
        return textField
    }()
    
    fileprivate lazy var shopLinkWebsiteTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText   = TextManager.linkWebsite.localized()
        textField.textField.fontSizePlaceholder(text: TextManager.linkWebsite.localized(),
                                                size: FontSize.h1.rawValue)
        textField.boderColor = UIColor.second
        return textField
    }()
    
    fileprivate lazy var productSaveInfoButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.save.localized(), for: .normal)
        button.backgroundColor = UIColor.second
        button.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        button.layer.masksToBounds = true
        button.isUserInteractionEnabled = true
        return button
    }()
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = TextManager.store
        self.navigationItem.rightBarButtonItem = self.editBarButtonItem
        layoutScrollView()
        layoutContenStackView()
        layoutProfileView()
        layoutProfilePhotoImage()
        layoutChangePhotoButton()
        layoutItemStackView()
    }
    
    // MARK: - Helper Method
    
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutContenStackView() {
        scrollView.addSubview(contenStackView)
        contenStackView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
                .inset(Dimension.shared.normalMargin)
            make.top.equalToSuperview()
                .offset(Dimension.shared.normalMargin)
            make.bottom.equalToSuperview()
                .offset(-Dimension.shared.largeMargin_56)
        }
    }
    
    private func layoutProfileView() {
        contenStackView.addArrangedSubview(avatarView)
        avatarView.snp.makeConstraints { (make) in
            make.height.equalTo(150)
        }
    }
    
    private func layoutProfilePhotoImage() {
        avatarView.addSubview(profilePhotoImage)
        profilePhotoImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(dimension.largeMargin_120)
        }
    }
    
    private func layoutChangePhotoButton() {
        avatarView.addSubview(changePhotoButton)
        changePhotoButton.snp.makeConstraints { (make) in
            make.top.equalTo(profilePhotoImage.snp.bottom)
                .offset(Dimension.shared.mediumMargin)
            make.centerX.width.equalTo(profilePhotoImage)
        }
    }

    private func layoutItemStackView() {
        contenStackView.addArrangedSubview(shopNameTextField)
        contenStackView.addArrangedSubview(shopPhoneTextField)
        contenStackView.addArrangedSubview(shopAddressTextView)
        contenStackView.addArrangedSubview(shopHotlineTextFields)
        contenStackView.addArrangedSubview(shopLinkWebsiteTextField)
        contenStackView.addArrangedSubview(productSaveInfoButton)
        productSaveInfoButton.snp.makeConstraints { (make) in
            make.height.equalTo(Dimension.shared.largeHeightButton)
        }
    }
    
}
