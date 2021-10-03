//
//  SignUpViewController.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 20/05/2021.
//

import UIKit

class SignUpViewController: BaseViewController {
    
    // MARK: - Variables
    
    fileprivate lazy var viewModel = SignUpViewModel()
    
    // MARK: - UI Elements
    
    let centerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis         = .vertical
        stackView.alignment    = .fill
        stackView.distribution = .fill
        stackView.spacing = dimension.normalMargin
        return stackView
    }()
    
    fileprivate lazy var emailTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText   = TextManager.email.localized()
        textField.textField
            .fontPlaceholder(text: TextManager.emailPlaceHolder.localized(),
                             size: FontSize.h1.rawValue)
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)),
                            for: .editingChanged)
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    fileprivate lazy var phoneTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText   = TextManager.shopPhone.localized()
        textField.textField
            .fontPlaceholder(text: TextManager.shopPhonePlaceholder.localized(),
                             size: FontSize.h1.rawValue)
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)),
                            for: .editingChanged)
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    fileprivate lazy var passwordTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText   = TextManager.password.localized()
        textField.textField
            .fontPlaceholder(text: TextManager.enterPassword.localized(),
                             size: FontSize.h1.rawValue)
        textField.textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)),
                            for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var confirmPasswordTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText   = TextManager.password.localized()
        textField.textField.fontPlaceholder(text: TextManager.confirmPW.localized(),
                                            size: FontSize.h1.rawValue)
        textField.textField.isSecureTextEntry = true
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
        button.isUserInteractionEnabled = false
        button.setTitleColor(UIColor.bodyText, for: .normal)
        button.addTarget(self, action: #selector(tapOnNextButton),
                         for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TextManager.signUpShop
        layoutScrollView()
        layoutCenterStackView()
        layoutEnterInfoUserShop()
        layoutNextButton()
    }
    
}

// MARK: - UI Action

extension SignUpViewController {
    
    @objc private func tapOnNextButton() {
        guard let email     = emailTextField.text,
              let phone     = phoneTextField.text,
              let password  = passwordTextField.text,
              let confirmPW = confirmPasswordTextField.text
        else {
            return
        }
        
        guard password == confirmPW else {
            AlertManager.shared.show(message: TextManager.passwordNotMatch.localized())
            return
        }
        
        guard password.count >= AppConfig.minPasswordLenght
                && confirmPW.count >= AppConfig.minPasswordLenght else {
            AlertManager.shared.show(message: TextManager.pwNotEnoughLength.localized())
            return
        }
        
        if viewModel.canSignUp(email: email,
                               phone: phone,
                               password: password,
                               confirmPassword: confirmPW) {
            let params: [String: Any] = ["email": email,
                                         "phone": phone,
                                         "password": password]
            let endPoint = UserShopEndPoint.signUp(params: params)
            self.showLoading()
            APIService.request(endPoint: endPoint, onSuccess: { (apiResponse) in
                self.hideLoading()
                if let userId = apiResponse.data?.dictionaryValue["id"]?.stringValue {
                    UserSessionManager.shared.saveUserId(userId)
                }
                let vc = VerifyOTPViewController()
                vc.email = email
                vc.isActiveAccount = true
                self.navigationController?.pushViewController(vc, animated: true)
               
            }, onFailure: { (error) in
                self.hideLoading()
                if error?.code == "400" {
                    AlertManager.shared.show(message: TextManager.existEmail.localized())
                } else {
                    AlertManager.shared.show(message: TextManager.errorMessage.localized())
                }
            }) {
                self.hideLoading()
                AlertManager.shared.show(message: TextManager.errorMessage.localized())
            }
            
        } else {
            self.hideLoading()
            AlertManager.shared.show(message: "Kiểm tra lại thông tin chưa đúng")
        }
    }
    
    @objc private func textFieldValueChange(_ textField: UITextField) {
        guard let email     = emailTextField.text,
              let phone     = phoneTextField.text,
              let password  = passwordTextField.text,
              let confirmPW = confirmPasswordTextField.text
        else {
            return
        }
        
        if email != "" && password != "" && confirmPW != "" && phone != "" {
            signUpButton.backgroundColor = UIColor.second
            signUpButton.isUserInteractionEnabled = true
            signUpButton.setTitleColor(UIColor.white, for: .normal)
        } else {
            signUpButton.backgroundColor = UIColor.disable
            signUpButton.isUserInteractionEnabled = false
            signUpButton.setTitleColor(UIColor.bodyText, for: .normal)
        }
    }
}

// MARK: - Layout

extension SignUpViewController {
    
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
    
    private func layoutEnterInfoUserShop() {
        centerStackView.addArrangedSubview(emailTextField)
        centerStackView.addArrangedSubview(phoneTextField)
        centerStackView.addArrangedSubview(passwordTextField)
        centerStackView.addArrangedSubview(confirmPasswordTextField)
    }
    
    private func layoutNextButton() {
        centerStackView.addArrangedSubview(signUpButton)
        signUpButton.snp.makeConstraints { (make) in
            make.height.equalTo(dimension.largeHeightButton)
        }
    }
}

