//
//  AddressViewController.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 01/07/2021.
//

import UIKit

class AddressViewController: BaseViewController {
    
    fileprivate (set) var province = Province()
    fileprivate (set) var district = District()
    fileprivate (set) var ward     = Ward()
    
    fileprivate lazy var viewModel = SignUpViewModel()
    
    let centerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis         = .vertical
        stackView.alignment    = .fill
        stackView.distribution = .fill
        stackView.spacing = dimension.normalMargin
        return stackView
    }()
    
    fileprivate lazy var shopNameTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText   = TextManager.shopName.localized()
        textField.textField
            .fontPlaceholder(text: TextManager.shopNamePlaceholder.localized(),
                             size: FontSize.h1.rawValue)
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)),
                            for: .editingChanged)
        
        return textField
    }()
    
    fileprivate lazy var shopAddressTextView: BaseTextView = {
        let textview = BaseTextView()
        textview.titleText = TextManager.shopAddressTitle
        textview.placeholder = TextManager.shopAddress
        return textview
    }()
    
    fileprivate lazy var provinceTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText = TextManager.provinceCity.localized()
        textField.rightTextfieldImage = ImageManager.dropDown
        
        textField.textField
            .fontPlaceholder(text: TextManager.provinceCity.localized(),
                             size: FontSize.h1.rawValue)
        
        textField.addTarget(self,
                            action: #selector(textFieldBeginEditing(_:)),
                            for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)),
                            for: .editingChanged)
        
        return textField
    }()
    
    fileprivate lazy var districtTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText = TextManager.district.localized()
        textField.rightTextfieldImage = ImageManager.dropDown
        
        textField.textField
            .fontPlaceholder(text: TextManager.district.localized(),
                             size: FontSize.h1.rawValue)
        
        textField.addTarget(self,
                            action: #selector(textFieldBeginEditing(_:)),
                            for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)),
                            for: .editingChanged)
        
        return textField
    }()
    
    fileprivate lazy var wardTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.textField.fontPlaceholder(text: TextManager.ward.localized(),
                                            size: FontSize.h1.rawValue)
        textField.titleText = TextManager.ward.localized()
        textField.rightTextfieldImage = ImageManager.dropDown
        textField.addTarget(self,
                            action: #selector(textFieldBeginEditing(_:)),
                            for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)),
                            for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var shopHotLineTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText   = TextManager.hotline.localized()
        textField.textField
            .fontPlaceholder(text: TextManager.hotlinePlaceholder.localized(),
                             size: FontSize.h1.rawValue)
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)),
                            for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var shopLinkWebsiteTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText   = TextManager.linkWebsite.localized()
        textField.textField
            .fontPlaceholder(text: TextManager.linkWebsite.localized(),
                             size: FontSize.h1.rawValue)
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)),
                            for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.signUp.localized(), for: .normal)
        button.backgroundColor = UIColor.disable
        button.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(tapOnSignIn),
                         for: .touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = TextManager.createAddress
        layoutScrollView()
        layoutCenterStackView()
        layoutItemAddStackView()
        layoutSignUpButton()
    }
    
    @objc private func tapOnSignIn() {
        guard let shopName  = shopNameTextField.text,
              let location  = shopAddressTextView.addressTextView.text,
              let hotline   = shopHotLineTextField.text,
              let linkWeb   = shopLinkWebsiteTextField.text
        else { return }
        guard let user = UserManager.user else { return }
        user.location = location
        user.name     = shopName
        user.hotLine  = hotline
        user.website  = linkWeb
        user.district = self.district
        user.province = self.province
        user.ward     = self.ward
        user.id       = UserManager.userId ?? ""
        self.showLoading()
        
        if viewModel.isValidInfo(shopName: shopName,
                                 location: location,
                                 hotline: hotline,
                                 linkWeb: linkWeb,
                                 province: self.province,
                                 district: self.district,
                                 ward: self.ward) {
            
            let endPoint = UserShopEndPoint.updateAddress(params: user.toDictionary())
            
            APIService.request(endPoint: endPoint) { [weak self] apiResponse in
                guard let self = self else { return }
                self.hideLoading()
                if let code = apiResponse.data?.dictionaryValue["code"]?.stringValue {
                    UserManager.saveCode(code)
                }
                guard let window = UIApplication.shared.keyWindow else { return }
                window.rootViewController = UINavigationController(rootViewController: MenuViewController())
            } onFailure: { error in
                self.hideLoading()
                AlertManager.shared.show(message: "Thông tin chưa đúng vui lòng kiểm tra lại")
            } onRequestFail: {
                self.hideLoading()
                AlertManager.shared.show(message: "Thông tin chưa đúng vui lòng kiểm tra lại")
            }
        } else {
            self.hideLoading()
            AlertManager.shared.show(message: "Thông tin chưa đúng vui lòng kiểm tra lại")
        }
    }
    
    @objc private func textFieldBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        let vc = LocationViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func checkEnableSaveButton() {
        guard let shopName  = shopNameTextField.text,
              let location  = shopAddressTextView.addressTextView.text,
              let hotline   = shopHotLineTextField.text,
              let linkWeb   = shopLinkWebsiteTextField.text,
              let province  = provinceTextField.text,
              let district  = districtTextField.text,
              let ward      = wardTextField.text
        else { return }
        if shopName != ""
            && location != ""
            && hotline != ""
            && linkWeb != ""
            && province != ""
            && district != ""
            && ward != ""
        {
            
            signUpButton.isUserInteractionEnabled = true
            signUpButton.backgroundColor = UIColor.thirdColor
            signUpButton.setTitleColor(UIColor.white, for: .normal)
        } else {
            signUpButton.isUserInteractionEnabled = false
            signUpButton.backgroundColor = UIColor.disable
            signUpButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    @objc private func textFieldValueChange(_ textField: UITextField) {
        checkEnableSaveButton()
    }
    
    private func layoutCenterStackView() {
        scrollView.addSubview(centerStackView)
        centerStackView.snp.makeConstraints { (make) in
            make.bottom
                .equalToSuperview()
                .offset(-dimension.normalMargin)
            make.centerX
                .equalToSuperview()
            make.width
                .equalTo(view)
                .offset(-dimension.normalMargin*2)
            make.top
                .equalToSuperview()
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutItemAddStackView() {
        centerStackView.addArrangedSubview(shopNameTextField)
        centerStackView.addArrangedSubview(shopAddressTextView)
        centerStackView.addArrangedSubview(provinceTextField)
        centerStackView.addArrangedSubview(districtTextField)
        centerStackView.addArrangedSubview(wardTextField)
        centerStackView.addArrangedSubview(shopHotLineTextField)
        centerStackView.addArrangedSubview(shopLinkWebsiteTextField)
    }
    
    private func layoutSignUpButton() {
        centerStackView.addArrangedSubview(signUpButton)
        signUpButton.snp.makeConstraints { (make) in
            make.height.equalTo(dimension.largeHeightButton)
        }
    }
}

extension AddressViewController: LocationViewControllerDelegate {
    func finishSelectLocation(_ province: Province,
                              _ district: District,
                              _ ward: Ward) {
        self.province = province
        self.district = district
        self.ward     = ward
        self.provinceTextField.text = province.name
        self.districtTextField.text = district.name
        self.wardTextField.text     = ward.name
        checkEnableSaveButton()
    }
}
