//
//  ForgotPasswordViewController.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 22/05/2021.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {
    
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
    
    fileprivate lazy var usernameTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText   = TextManager.email.localized()
        textField.placeholder = TextManager.emailPlaceHolder.localized()
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)),
                            for: .editingChanged)
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    fileprivate lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.next.localized(), for: .normal)
        button.backgroundColor = UIColor.disable
        button.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(tapOnNextButton),
                         for: .touchUpInside)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = TextManager.forgotPW
        layoutTopView()
        layoutLogoImageView()
        layoutUsernameTextField()
        layoutNextButton()
    }
     
    @objc private func textFieldValueChange(_ textField: UITextField) {
        guard let username = usernameTextField.text else { return }
        
        if username != "" && username.isValidEmail {
            self.nextButton.isUserInteractionEnabled = true
            self.nextButton.backgroundColor = UIColor.thirdColor
        } else {
            self.nextButton.backgroundColor = UIColor.disable
            self.nextButton.isUserInteractionEnabled = false
        }
    }
    
    @objc private func tapOnNextButton() {
        guard let email = usernameTextField.text else { return }
        let params: [String: Any] = ["email": email]
        let endPoint = UserShopEndPoint.resendOTP(params: params)
        
        APIService.request(endPoint: endPoint) { [weak self] apiResponse in
            guard let self = self else { return }
            if let userId = apiResponse.data?.dictionaryValue["shopId"]?.stringValue {
                UserSessionManager.shared.saveUserId(userId)
            }
            let vc = VerifyOTPViewController()
            vc.email = email
            vc.isForgot = true
            self.navigationController?.pushViewController(vc, animated: true)
        } onFailure: { error in
            AlertManager.shared.show(message: error?.message ?? "")
        } onRequestFail: {
            AlertManager.shared.show(message: TextManager.errorMessage.localized())
        }
    }
    
}

// MARK: - Layout

extension ForgotPasswordViewController {
    
    private func layoutTopView() {
        view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
                .offset(-Dimension.shared.largeMargin_120)
            make.left.right.equalToSuperview()
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
    
    private func layoutUsernameTextField() {
        view.addSubview(usernameTextField)
        usernameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(logoImageView.snp.bottom)
                .offset(Dimension.shared.largeMargin)
            make.left.equalToSuperview()
                .offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview()
                .offset(-Dimension.shared.normalMargin)
        }
    }
    
    private func layoutNextButton() {
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.top.equalTo(usernameTextField.snp.bottom)
                .offset(Dimension.shared.normalMargin)
            make.left.right.equalTo(usernameTextField)
            make.height.equalTo(Dimension.shared.largeHeightButton)
        }
    }
}
