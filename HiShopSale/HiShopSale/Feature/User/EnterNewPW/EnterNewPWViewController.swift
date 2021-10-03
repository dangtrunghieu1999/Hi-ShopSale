//
//  EnterNewPWViewController.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 23/05/2021.
//

import UIKit

class EnterNewPWViewController: BaseViewController {

    // MARK: - UI Elements
    
    let topView: UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.icon_logo2
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let centerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis         = .vertical
        stackView.alignment    = .fill
        stackView.distribution = .fill
        stackView.spacing = dimension.normalMargin
        return stackView
    }()
    
    fileprivate lazy var passwordTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.placeholder = TextManager.password.localized()
        textField.textAlignment = .left
        textField.layer.borderColor = UIColor.separator.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = Dimension.shared.conerRadiusMedium
        textField.layer.masksToBounds = true
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)),
                            for: .editingChanged)
        textField.isSecureTextEntry = true
        return textField
    }()

    fileprivate lazy var confirmPWTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.placeholder = TextManager.confirmPW.localized()
        textField.textAlignment = .left
        textField.layer.borderColor = UIColor.separator.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = Dimension.shared.conerRadiusMedium
        textField.layer.masksToBounds = true
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)),
                            for: .editingChanged)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    fileprivate lazy var changePWdButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.changePassword.localized(), for: .normal)
        button.backgroundColor = UIColor.disable
        button.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(tapOnNextButton), for: .touchUpInside)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    var code: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = TextManager.createNewPW
        layoutCenterStackView()
        layoutPasswordTextField()
        layoutChangePWButton()
        layoutTopView()
        layoutLogoImageView()
    }
    
    
    @objc private func textFieldValueChange(_ textField: UITextField) {
        guard let password  = passwordTextField.text else { return }
        guard let confirmPW = confirmPWTextField.text else { return }
        if password != "" && confirmPW != ""{
            self.changePWdButton.isUserInteractionEnabled = true
            self.changePWdButton.backgroundColor          = UIColor.primary
        } else {
            self.changePWdButton.backgroundColor          = UIColor.disable
            self.changePWdButton.isUserInteractionEnabled = false
        }
    }
    
    @objc private func tapOnNextButton() {
        guard let password  = passwordTextField.text else { return }
        let params: [String: Any] = ["otp": code,
                                     "shopId": UserManager.userId ?? "",
                                     "password": password]
        let endPoint = UserShopEndPoint.forgotPW(params: params)
        self.showLoading()
        APIService.request(endPoint: endPoint) { [weak self] apiResponse in
            guard let self = self else { return }
            self.hideLoading()
            AlertManager.shared.show(TextManager.alertTitle.localized(),
                                     message: TextManager.resetPWSuccessMessage.localized(),
                                     buttons: [TextManager.IUnderstand.localized()],
                                     tapBlock: { (action, index) in
                                        UIViewController.setRootVCBySinInVC()
            })
        } onFailure: { error in
            self.hideLoading()
            AlertManager.shared.show(TextManager.alertTitle.localized(),
                                     message: TextManager.errorMessage.localized())
        } onRequestFail: {
            self.hideLoading()
            AlertManager.shared.show(TextManager.alertTitle.localized(),
                                     message: TextManager.errorMessage.localized())
        }

    }
}

// MARK: - Layout

extension EnterNewPWViewController {
    
    private func layoutCenterStackView() {
        view.addSubview(centerStackView)
        centerStackView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
                .offset(dimension.normalMargin)
            make.right.equalToSuperview()
                .inset(dimension.normalMargin)
            make.centerY.equalToSuperview()
                .offset(Dimension.shared.largeMargin_120)
        }
    }
    
    private func layoutPasswordTextField() {
        centerStackView.addArrangedSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { (make) in
            make.height.equalTo(Dimension.shared.largeHeightButton)
        }
        centerStackView.addArrangedSubview(confirmPWTextField)
        confirmPWTextField.snp.makeConstraints { (make) in
            make.height.equalTo(Dimension.shared.largeHeightButton)
        }
    }
    
    private func layoutChangePWButton() {
        centerStackView.addArrangedSubview(changePWdButton)
        changePWdButton.snp.makeConstraints { (make) in
            make.height.equalTo(Dimension.shared.largeHeightButton)
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
}
