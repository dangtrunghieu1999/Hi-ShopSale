//
//  SignUpViewController.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 20/05/2021.
//

import UIKit

class SignUpViewController: BaseViewController {
    
    // MARK: - Variables
    
    fileprivate (set) var selectedProvince: Province?
    fileprivate (set) var selecteDistrict:  District?
    fileprivate (set) var selectedWard:     Ward?
    
    fileprivate (set) var provinces:    [Province] = []
    fileprivate (set) var districts:    [District] = []
    fileprivate (set) var wards:        [Ward]     = []
    
    // MARK: - UI Elements
    
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
        textField.textField.fontSizePlaceholder(text: TextManager.shopNamePlaceholder.localized(),
                                                size: FontSize.h1.rawValue)
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        
        return textField
    }()
    
    fileprivate lazy var shopPhoneTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText   = TextManager.shopPhone.localized()
        textField.textField.fontSizePlaceholder(text: TextManager.shopPhonePlaceholder.localized(),
                                                size: FontSize.h1.rawValue)
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var passwordTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText   = TextManager.password.localized()
        textField.textField.fontSizePlaceholder(text: TextManager.enterPassword.localized(),
                                                size: FontSize.h1.rawValue)
        textField.textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        return textField
    }()

    
    fileprivate lazy var shopAddressTextView: BaseTextView = {
        let textview = BaseTextView()
        textview.titleText = TextManager.shopAddressTitle
        textview.placeholder = TextManager.shopAddress
        return textview
    }()
    
    fileprivate lazy var provincePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    fileprivate lazy var districtPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    fileprivate lazy var wardPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    fileprivate lazy var provinceTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.placeholder = TextManager.provinceCity.localized()
        textField.titleText = TextManager.provinceCity.localized()
        textField.rightTextfieldImage = ImageManager.dropDown
        textField.textFieldInputView = provincePickerView
        textField.addTarget(self,
                            action: #selector(textFieldBeginEditing(_:)),
                            for: .editingDidBegin)
        textField.addTarget(self,
                            action: #selector(textFieldDidEndEditing(_:)),
                            for: .editingDidEnd)
        return textField
    }()
    
    fileprivate lazy var districtTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.placeholder = TextManager.district.localized()
        textField.titleText = TextManager.district.localized()
        textField.rightTextfieldImage = ImageManager.dropDown
        textField.isUserInteractionEnabled = false
        textField.textField.backgroundColor = UIColor.lightDisable
        textField.textFieldInputView = districtPickerView
        textField.addTarget(self,
                            action: #selector(textFieldBeginEditing(_:)),
                            for: .editingDidBegin)
        textField.addTarget(self,
                            action: #selector(textFieldDidEndEditing(_:)),
                            for: .editingDidEnd)
        return textField
    }()
    
    fileprivate lazy var wardTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.placeholder = TextManager.ward.localized()
        textField.titleText = TextManager.ward.localized()
        textField.rightTextfieldImage = ImageManager.dropDown
        textField.isUserInteractionEnabled = false
        textField.textField.backgroundColor = UIColor.lightDisable
        textField.textFieldInputView = wardPickerView
        textField.addTarget(self,
                            action: #selector(textFieldValueChange(_:)),
                            for: .valueChanged)
        textField.addTarget(self,
                            action: #selector(textFieldBeginEditing(_:)),
                            for: .editingDidBegin)
        textField.addTarget(self,
                            action: #selector(textFieldDidEndEditing(_:)),
                            for: .editingDidEnd)
        return textField
    }()
    
    fileprivate lazy var shopHotLineTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText   = TextManager.hotline.localized()
        textField.textField.fontSizePlaceholder(text: TextManager.hotlinePlaceholder.localized(),
                                                size: FontSize.h1.rawValue)
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var shopMapTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText   = TextManager.linkGGMap.localized()
        textField.textField.fontSizePlaceholder(text: TextManager.linkGGMapPlaceholder.localized(),
                                                size: FontSize.h1.rawValue)
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var shopLinkWebsiteTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText   = TextManager.linkWebsite.localized()
        textField.textField.fontSizePlaceholder(text: TextManager.linkWebsite.localized(),
                                                size: FontSize.h1.rawValue)
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        return textField
    }()


        
    fileprivate lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.signUp.localized(), for: .normal)
        button.backgroundColor = UIColor.disable
        button.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(tapOnSignIn), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TextManager.signUpShop
        layoutScrollView()
        layoutCenterStackView()
        layoutEnterInfoUserShop()
        layoutSignUpButton()
    }

}

// MARK: - UI Action

extension SignUpViewController {

    @objc private func tapOnSignIn() {
        let vc = VerifyOTPViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func textFieldValueChange(_ textField: UITextField) {

    }
    
    @objc private func textFieldBeginEditing(_ textField: UITextField) {
        
    }
    
    @objc internal override func textFieldDidEndEditing(_ textField: UITextField) {
    
    }
}

// MARK: - Layout

extension SignUpViewController {
    
    
    private func layoutCenterStackView() {
        scrollView.addSubview(centerStackView)
        centerStackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
                .offset(Dimension.shared.normalMargin)
            make.left.equalTo(view)
                .offset(Dimension.shared.normalMargin)
            make.right.equalTo(view)
                .offset(-Dimension.shared.normalMargin)
            make.bottom.equalToSuperview()
                .offset(-Dimension.shared.normalMargin)
        }
    }
    
    private func layoutEnterInfoUserShop() {
        centerStackView.addArrangedSubview(shopNameTextField)
        centerStackView.addArrangedSubview(shopPhoneTextField)
        centerStackView.addArrangedSubview(passwordTextField)
        centerStackView.addArrangedSubview(shopAddressTextView)
        centerStackView.addArrangedSubview(provinceTextField)
        centerStackView.addArrangedSubview(districtTextField)
        centerStackView.addArrangedSubview(wardTextField)
        centerStackView.addArrangedSubview(shopHotLineTextField)
        centerStackView.addArrangedSubview(shopMapTextField)
        centerStackView.addArrangedSubview(shopLinkWebsiteTextField)
    }
    
    private func layoutSignUpButton() {
        centerStackView.addArrangedSubview(signUpButton)
        signUpButton.snp.makeConstraints { (make) in
            make.height.equalTo(Dimension.shared.largeHeightButton)
        }
    }
    
}

// MARK: - UIPickerViewDelegate

extension SignUpViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,
                    inComponent component: Int) {
        if pickerView == provincePickerView {
            provinceTextField.textField.text = provinces[safe:row]?.name ?? ""
            selectedProvince = provinces[safe:row]
        } else if pickerView == districtPickerView {
            districtTextField.textField.text = districts[safe:row]?.name ?? ""
            selecteDistrict = districts[safe:row]
        } else if pickerView == wardPickerView {
            wardTextField.textField.text = wards[safe:row]?.name ?? ""
            selectedWard = wards[safe:row]
        }
    }
}

// MARK: - UIPickerViewDatasource

extension SignUpViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        if pickerView == provincePickerView {
            return provinces.count
        } else if pickerView == districtPickerView {
            return districts.count
        } else {
            return wards.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {
        if pickerView == provincePickerView {
            return provinces[safe: row]?.name
        } else if pickerView == districtPickerView {
            return districts[safe: row]?.name
        } else {
            return wards[safe: row]?.name
        }
    }
}


