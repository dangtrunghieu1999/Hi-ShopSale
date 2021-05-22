//
//  SignInViewController.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 20/05/2021.
//

import UIKit

class SignInViewController: BaseViewController {
    
    
    // MARK: - UI Elements
    
    let topView: UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.icon_logo
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    fileprivate let welcomeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.welcomeShop
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue, weight: .bold)
        return label
    }()
    
    let centerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis         = .vertical
        stackView.alignment    = .fill
        stackView.distribution = .fill
        stackView.spacing = dimension.normalMargin
        return stackView
    }()
    
    fileprivate lazy var usernameTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText   = TextManager.username.localized()
        textField.placeholder = TextManager.enterUsername.localized()
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        textField.keyboardType = .numberPad
        
        return textField
    }()
    
    fileprivate lazy var passwordTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText   = TextManager.password.localized()
        textField.placeholder = TextManager.enterPassword.localized()
        textField.textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var signInButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.signIn.localized(), for: .normal)
        button.backgroundColor = UIColor.disable
        button.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(tapOnSignIn), for: .touchUpInside)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    fileprivate lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.signUp.localized(), for: .normal)
        button.backgroundColor = UIColor.primary
        button.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(tapOnSignIn), for: .touchUpInside)
        return button
    }()
    
    lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitleColor(UIColor.second, for: .normal)
        button.setTitle(TextManager.forgotPassword.localized(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                                    weight: .semibold)
        button.addTarget(self, action: #selector(tapOnForgotPassword), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TextManager.signIn
        layoutForgotPasswordButton()
        layoutCenterStackView()
        layoutUsernameTextField()
        layoutPasswordTextField()
        layoutSignInButton()
        layoutSignUpButton()
        layoutTopView()
        layoutLogoImageView()
        layoutWelcomeTitleLabel()
    }
    
}

// MARK: - UI Action

extension SignInViewController {
     
    @objc private func tapOnForgotPassword() {
        let vc = ForgotPasswordViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func tapOnSignIn() {
        let vc = MenuViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func textFieldValueChange(_ textField: UITextField) {
        guard let username = usernameTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        if username != "" && password != "" {
            self.signInButton.isUserInteractionEnabled = true
            self.signInButton.backgroundColor = UIColor.primary
        } else {
            self.signInButton.backgroundColor = UIColor.disable
            self.signInButton.isUserInteractionEnabled = false
        }
    }
}

// MARK: - Layout

extension SignInViewController {
    
    private func layoutForgotPasswordButton() {
        view.addSubview(forgotPasswordButton)
        forgotPasswordButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
                .offset(-dimension.normalMargin)
            make.centerX.equalToSuperview()
        }
    }
    
    private func layoutCenterStackView() {
        view.addSubview(centerStackView)
        centerStackView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
                .offset(dimension.normalMargin)
            make.right.equalToSuperview()
                .inset(dimension.normalMargin)
            make.bottom.equalTo(forgotPasswordButton.snp.top)
                .offset(-dimension.largeMargin)
        }
    }
    
    private func layoutUsernameTextField() {
        centerStackView.addArrangedSubview(usernameTextField)
    }
    
    private func layoutPasswordTextField() {
        centerStackView.addArrangedSubview(passwordTextField)
    }
    
    private func layoutSignInButton() {
        centerStackView.addArrangedSubview(signInButton)
        signInButton.snp.makeConstraints { (make) in
            make.height.equalTo(dimension.largeHeightButton)
        }
    }
    
    private func layoutSignUpButton() {
        centerStackView.addArrangedSubview(signUpButton)
        signUpButton.snp.makeConstraints { (make) in
            make.height.equalTo(dimension.largeHeightButton)
        }
    }
    
    private func layoutTopView() {
        view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(centerStackView.snp.top)
        }
    }
    
    private func layoutLogoImageView() {
        topView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(view).multipliedBy(0.5)
            make.height.equalTo(logoImageView.snp.width)
        }
    }
    
    private func layoutWelcomeTitleLabel() {
        topView.addSubview(welcomeTitleLabel)
        welcomeTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(logoImageView.snp.bottom)
                .offset(Dimension.shared.normalMargin)
            make.left.right.equalTo(centerStackView)
        }
    }
}
