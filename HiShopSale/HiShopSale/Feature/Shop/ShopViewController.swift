//
//  ShopViewController.swift
//  HiShopSale
//
//  Created by Dang Trung Hieu on 5/12/21.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage
import Photos

class ShopViewController: BaseViewController {
    
    // MARK: - Variables
    private var userShop = User()
    
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
    
    fileprivate var viewModel = ShopHomeViewModel()
    fileprivate var cacheImage: UIImage?
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
    
    lazy var profilePhotoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.avatarDefault
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = dimension.largeMargin_120 / 2
        imageView.layer.borderColor = UIColor.separator.withAlphaComponent(0.7).cgColor
        imageView.layer.borderWidth = 1
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnChangePhoto))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    fileprivate lazy var shopNameTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText   = TextManager.shopName.localized()
        textField.textField.fontPlaceholder(text: TextManager.shopNamePlaceholder.localized(),
                                                size: FontSize.h1.rawValue)
        textField.boderColor = UIColor.second
        return textField
    }()
    
    fileprivate lazy var shopPhoneTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText   = TextManager.shopPhone.localized()
        textField.textField.fontPlaceholder(text: TextManager.shopNamePlaceholder.localized(),
                                                size: FontSize.h1.rawValue)
        textField.boderColor = UIColor.second
        textField.keyboardType = .numberPad
        return textField
    }()
    
    fileprivate lazy var shopAddressTextView: BaseTextView = {
        let textview = BaseTextView()
        textview.titleText   = TextManager.shopAddressTitle
        textview.placeholder = TextManager.shopAddress
        textview.boderColor  = UIColor.second
        textview.addressTextView.textColor = UIColor.bodyText
        return textview
    }()
    
    fileprivate lazy var shopHotlineTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText   = TextManager.hotline.localized()
        textField.textField.fontPlaceholder(text: TextManager.hotlinePlaceholder.localized(),
                                                size: FontSize.h1.rawValue)
        textField.boderColor = UIColor.second
        textField.keyboardType = .numberPad
        return textField
    }()
    
    fileprivate lazy var shopLinkWebsiteTextField: BaseTextView = {
        let textview = BaseTextView()
        textview.titleText   = TextManager.linkWebsite
        textview.placeholder = TextManager.linkWebsite
        textview.boderColor  = UIColor.second
        return textview
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
        layoutItemStackView()
        getInfoShop()
    }
    
    // MARK: - Helper Method
    
    // MARK: - Process Images Helper
    
    fileprivate func processAfterPickerImage(_ image: UIImage?) {
        guard let image = image else {
            AlertManager.shared.showDefaultError()
            return
        }
        
        self.performUpdateAvatar(with:
        image.resizeImage(targetSize: CGSize(width: 400,
                                            height: 400)))
    }
    
    fileprivate func performUpdateAvatar(with image: UIImage?) {
        guard let image = image else {
            AlertManager.shared.showDefaultError()
            return
        }
        
        self.showLoading()
        
        self.viewModel.uploadImage(image: image, completion: { [weak self](url) in
            guard let self = self else { return }
            AlertManager.shared.showToast(message: "Cập nhập thành công")
            self.profilePhotoImage.image = image
            self.getInfoShop()
            self.hideLoading()
        }) { [weak self] in
            self?.hideLoading()
            AlertManager.shared.showDefaultError()
        }
    }
    
    @objc private func tapOnChangePhoto() {
        AlertManager.shared.show(style: .actionSheet,
                                 buttons: [TextManager.updateAvatar.localized(),
                                TextManager.viewAvatar.localized()]) { (action, index) in
            if index == 0 {
                AppRouter.presentToImagePicker(pickerDelegate: self)
            } else {
                let avatar = self.userShop.avatar
                AppRouter.presentPopupImage(urls: [avatar])
            }
        }
    }
    
    func getInfoShop() {
        let endPoint = UserShopEndPoint.getShopInfo
        self.showLoading()
        APIService.request(endPoint: endPoint, onSuccess: { (apiResponse) in
            self.hideLoading()
            guard let userProfile = apiResponse.toObject(User.self) else { return }
            self.userShop = userProfile
            self.configDataShop()
        }, onFailure: { (apiError) in
            
        }) {
            
        }
    }
    
    func configDataShop() {
        self.profilePhotoImage.loadImage(by: self.userShop.avatar)
        self.shopNameTextField.text  = self.userShop.name
        self.shopPhoneTextField.text = self.userShop.phone
        self.shopAddressTextView
            .addressTextView.text    = self.userShop.addressShop
        self.shopHotlineTextField.text = "19002540"
        let urlWebsite = "https://tiki.vn/cua-hang/dien-tu-hoang-thinh"
        let attributedString = self.setupLinkTextView(urlWebsite)
        
        self.shopLinkWebsiteTextField
            .addressTextView.attributedText = attributedString
    }
    
    func setupLinkTextView(_ url: String) -> NSMutableAttributedString  {
        let attrs1 = [NSAttributedString.Key.font
                        : UIFont.systemFont(ofSize: FontSize.h1.rawValue)]
        let attributedString = NSMutableAttributedString(string: url,
                                                         attributes: attrs1)
        attributedString.addAttribute(.link, value: url,
                                             range: NSRange(location: 0,
                                             length: url.count))
        return attributedString
    }
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutContenStackView() {
        scrollView.addSubview(contenStackView)
        contenStackView.snp.makeConstraints { (make) in
            make.left.right
                .equalTo(view)
                .inset(dimension.normalMargin)
            make.top
                .equalToSuperview()
                .offset(dimension.normalMargin)
            make.bottom
                .equalToSuperview()
                .offset(-dimension.largeMargin_56)
        }
    }
    
    private func layoutProfileView() {
        contenStackView.addArrangedSubview(avatarView)
        avatarView.snp.makeConstraints { (make) in
            make.height.equalTo(120)
        }
    }
    
    private func layoutProfilePhotoImage() {
        avatarView.addSubview(profilePhotoImage)
        profilePhotoImage.snp.makeConstraints { (make) in
            make.centerX
                .equalToSuperview()
            make.width.height
                .equalTo(dimension.largeMargin_120)
        }
    }
    
    private func layoutItemStackView() {
        contenStackView.addArrangedSubview(shopNameTextField)
        contenStackView.addArrangedSubview(shopPhoneTextField)
        contenStackView.addArrangedSubview(shopAddressTextView)
        contenStackView.addArrangedSubview(shopHotlineTextField)
        contenStackView.addArrangedSubview(shopLinkWebsiteTextField)
        contenStackView.addArrangedSubview(productSaveInfoButton)
        productSaveInfoButton.snp.makeConstraints { (make) in
            make.height.equalTo(dimension.largeHeightButton)
        }
    }
}


// MARK: - ImagePickerControllerDelegate

extension ShopViewController: ImagePickerControllerDelegate {
    func imagePickerController(_ picker: ImagePickerController, shouldLaunchCameraWithAuthorization status: AVAuthorizationStatus) -> Bool {
        return true
    }
    
    func imagePickerController(_ picker: ImagePickerController,
                               didFinishPickingImageAssets assets: [PHAsset]) {
        UIViewController.topViewController()?.dismiss(animated: true, completion: {
            assets.first?.getUIImage(completion: { (image) in
                guard let image = image else { return }
                self.processAfterPickerImage(image)
            })
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: ImagePickerController) {
        UIViewController.topViewController()?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerCpmtroller(_ picker: ImagePickerController, didTakePhoto photo: UIImage?) {
        UIViewController.topViewController()?.dismiss(animated: true, completion: {
            self.processAfterPickerImage(photo)
        })
    }
}
