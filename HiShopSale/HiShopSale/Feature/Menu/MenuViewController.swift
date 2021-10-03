//
//  MenuViewController.swift
//  HiShopSale
//
//  Created by Dang Trung Hieu on 5/12/21.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage
import Photos

import IQKeyboardManagerSwift

class MenuViewController: BaseViewController {
    
    // MARK: - Variables
    
    var isSlideInMenuPresented  = false
    lazy var slideInMenuPadding: CGFloat = self.view.frame.width * 0.30
    var viewModel = MenuViewModel()
    
    // MARK: - UI Elements
    
    fileprivate lazy var menuView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.second
        return view
    }()
    
    fileprivate lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.blackColor
        tableView.showsVerticalScrollIndicator = false
        tableView.registerReusableCell(MenuTableViewCell.self)
        return tableView
    }()
    
    // MARK: - Variables
    private var userShop = User()
    
    lazy var editBarButtonItem: UIBarButtonItem = {
        
        let barButtonItem = UIBarButtonItem(title: TextManager.edit,
                                            style: .done,
                                            target: self,
                                            action: #selector(tapOnChangeEdit))
        let attributedText  = [NSAttributedString.Key.font:
                                UIFont.systemFont(ofSize: FontSize.h1.rawValue),
                               NSAttributedString.Key.foregroundColor: UIColor.black]
        barButtonItem.setTitleTextAttributes(attributedText, for: .normal)
        
        return barButtonItem
    }()
    
    fileprivate var viewModelShop = ShopHomeViewModel()
    fileprivate var cacheImage: UIImage?
    // MARK: - UI Elements
    
    lazy var menuScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isUserInteractionEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchInScrollView))
        tapGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapGesture)
        return scrollView
    }()
    
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
    
    let nameContainerView = UIView()
    
    fileprivate lazy var shopNameTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText   = TextManager.shopName.localized()
        textField.textField.fontPlaceholder(text: TextManager.shopNamePlaceholder.localized(),
                                            size: FontSize.h1.rawValue)
        textField.boderColor = UIColor.second
        textField.addTarget(self,
                            action: #selector(textFieldValueChange(_:)),
                            for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var shopPhoneTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText   = TextManager.shopPhone.localized()
        textField.textField.fontPlaceholder(text: TextManager.shopPhonePlaceholder.localized(),
                                            size: FontSize.h1.rawValue)
        textField.boderColor = UIColor.second
        textField.keyboardType = .numberPad
        textField.addTarget(self,
                            action: #selector(textFieldValueChange(_:)),
                            for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var shopAddressTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText   = TextManager.shopAddressTitle.localized()
        textField.textField.fontPlaceholder(text: TextManager.shopAddress.localized(),
                                            size: FontSize.h1.rawValue)
        textField.boderColor = UIColor.second
        textField.addTarget(self,
                            action: #selector(textFieldValueChange(_:)),
                            for: .editingChanged)
        return textField
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
        textField.boderColor = UIColor.second
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
        textField.boderColor = UIColor.second
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
        textField.boderColor = UIColor.second
        return textField
    }()
    
    fileprivate lazy var shopHotlineTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText   = TextManager.hotline.localized()
        textField.textField.fontPlaceholder(text: TextManager.hotlinePlaceholder.localized(),
                                            size: FontSize.h1.rawValue)
        textField.boderColor = UIColor.second
        textField.keyboardType = .numberPad
        textField.boderColor = UIColor.second
        textField.addTarget(self,
                            action: #selector(textFieldValueChange(_:)),
                            for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var shopLinkWebsiteTextField: BaseTextView = {
        let textview = BaseTextView()
        textview.titleText   = TextManager.linkWebsite
        textview.placeholder = TextManager.linkWebsite
        textview.boderColor  = UIColor.second
        return textview
    }()
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = TextManager.menuShop
        self.menuView.pintoMenu(view, with: slideInMenuPadding)
        self.containerView.edgeTo(view)
        self.setLeftNavigationBar(ImageManager.icon_menu)
        self.setupEditBarButtonItem()
        self.layoutTableView()
        self.layoutMenuScrollView()
        self.layoutContenStackView()
        self.layoutProfileView()
        self.layoutProfilePhotoImage()
        self.layoutNameContainerView()
        self.layoutShopNameTextField()
        self.layoutShopPhoneTextField()
        self.layoutItemStackView()
        self.getInfoShop()
    }
    
    // MARK: - Ovveride Method
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc private func tapOnChangeEdit() {
        guard let name  = shopNameTextField.text,
              let phone = shopPhoneTextField.text,
              let location = shopAddressTextField.text,
              let hotline  = shopHotlineTextField.text,
              let website = shopLinkWebsiteTextField.addressTextView.text
        else { return }
        self.userShop.name  = name
        self.userShop.phone = phone
        self.userShop.location = location
        self.userShop.hotLine  = hotline
        self.userShop.website  = website
        
        let endPoint = UserShopEndPoint.updateInfoUser(params: userShop.toDictionary())
        self.showLoading()
        APIService.request(endPoint: endPoint) { [weak self] apiResponse in
            guard let self = self else { return}
            self.hideLoading()
            AlertManager.shared.showToast(message: "Cập nhập thành công")
        } onFailure: { error in
            self.hideLoading()
            AlertManager.shared.show(message: "Cập nhập thất bại vui lòng kiểm tra lại thông tin")
        } onRequestFail: {
            self.hideLoading()
            AlertManager.shared.show(message: "Cập nhập thất bại vui lòng kiểm tra lại thông tin")
        }
    }
    
    private func setupEditBarButtonItem() {
        self.navigationItem.rightBarButtonItem = self.editBarButtonItem
    }
    
    @objc private func textFieldValueChange(_ textField: UITextField) {
        checkChangeEdit()
    }
    
    func checkChangeEdit() {
        guard let name  = shopNameTextField.text,
              let phone = shopPhoneTextField.text,
              let location = shopAddressTextField.text,
              let province = provinceTextField.text,
              let district = districtTextField.text,
              let ward     = wardTextField.text,
              let hotline  = shopHotlineTextField.text
        else { return }
        if name == userShop.name &&
            phone == userShop.phone &&
            location == userShop.location &&
            province == userShop.province.name &&
            district == userShop.district.name &&
            ward == userShop.ward.name &&
            hotline == userShop.hotLine {
            self.editBarButtonItem.title = TextManager.edit
        } else {
            self.editBarButtonItem.title = TextManager.done
        }
    }
    
    fileprivate func processAfterPickerImage(_ image: UIImage?) {
        guard let image = image else {
            AlertManager.shared.showDefaultError()
            return
        }
        
        self.performUpdateAvatar(with:
                                    image.resizeImage(targetSize: CGSize(width: 400,
                                                                         height: 400)))
    }
    
    @objc private func textFieldBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        let vc = LocationViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func performUpdateAvatar(with image: UIImage?) {
        guard let image = image else {
            AlertManager.shared.showDefaultError()
            return
        }
        
        self.showLoading()
        
        self.viewModelShop.uploadImage(image: image, completion: { [weak self](url) in
            guard let self = self else { return }
            AlertManager.shared.show(message: "Cập nhập thành công")
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
        APIService.request(endPoint: endPoint, onSuccess: { (apiResponse) in
            guard let userProfile = apiResponse.toObject(User.self) else { return }
            self.userShop = userProfile
            self.configDataShop()
        }, onFailure: { (apiError) in
            
        }) {
        }
    }
    
    func configDataShop() {
        let user = self.userShop
        self.profilePhotoImage.loadImage(by: user.avatar)
        self.shopNameTextField.text     = user.name
        self.shopPhoneTextField.text    = user.phone
        self.shopAddressTextField.text  = user.location
        self.shopHotlineTextField.text  = user.hotLine
        self.provinceTextField.text     = user.province.name
        self.districtTextField.text     = user.district.name
        self.wardTextField.text         = user.ward.name
        let urlWebsite                  = user.website
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
    
    // MARK: - UI Action
    
    override func touchUpInLeftBarButtonItem() {
        UIView.animate(withDuration: 0.5, delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut) {
            self.containerView.frame.origin.x =
                self.isSlideInMenuPresented ? 0 : self.containerView.frame.width - self.slideInMenuPadding
        } completion: { (finished) in
            self.isSlideInMenuPresented.toggle()
            self.containerView.isHidden = self.isSlideInMenuPresented
        }
    }
}

// MARK: - Layout

extension MenuViewController {
    
    private func layoutTableView() {
        menuView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func layoutMenuScrollView() {
        containerView.addSubview(menuScrollView)
        menuScrollView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
            }
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
    }
    
    private func layoutContenStackView() {
        menuScrollView.addSubview(contenStackView)
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
    
    private func layoutNameContainerView() {
        contenStackView.addArrangedSubview(nameContainerView)
    }
    
    private func layoutShopNameTextField() {
        nameContainerView.addSubview(shopNameTextField)
        shopNameTextField.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.trailing.equalTo(nameContainerView.snp.centerX)
                .offset(-dimension.mediumMargin)
        }
    }
    
    private func layoutShopPhoneTextField() {
        nameContainerView.addSubview((shopPhoneTextField))
        shopPhoneTextField.snp.makeConstraints { (make) in
            make.trailing.top.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.leading.equalTo(nameContainerView.snp.centerX)
                .offset(dimension.mediumMargin)
        }
    }
    
    
    private func layoutItemStackView() {
        contenStackView.addArrangedSubview(shopAddressTextField)
        contenStackView.addArrangedSubview(provinceTextField)
        contenStackView.addArrangedSubview(districtTextField)
        contenStackView.addArrangedSubview(wardTextField)
        contenStackView.addArrangedSubview(shopHotlineTextField)
        contenStackView.addArrangedSubview(shopLinkWebsiteTextField)
    }
}

// MARK: - UITableViewDelegate

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = MenuType(rawValue: indexPath.row + 1)
        switch type {
        case .home:
            let vc = MenuViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .product:
            let vc = ProductViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .plus:
            let vc = CreateProductViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .order:
            let vc = ManagerOrderViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .chat:
            let vc = ChangePWViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .statistics:
            let vc = StatisticalViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .notification:
            let vc = NotificationViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .logout:
            AlertManager.shared.showConfirm(TextManager.statusLogOut.localized())
            { (action) in
                
                let endPoint = UserShopEndPoint.postFCMToken(params: ["FCMToken": ""])
                
                APIService.request(endPoint: endPoint) { apiResponse in
                    
                } onFailure: { error in
                    
                } onRequestFail: {
                    
                }
                UserManager.logout()
                guard let window = UIApplication.shared.keyWindow else { return }
                window.rootViewController = UINavigationController(rootViewController: SignInViewController())
            }
        default:
            break
        }
    }
}

// MARK: - UITableViewDataSource

extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuType.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row  = indexPath.row
        let cell: MenuTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configData(image: viewModel.menuImage[row],
                        title: viewModel.menuTitle[row])
        cell.backgroundColor = UIColor.clear
        return cell
    }
}

// MARK: - ImagePickerControllerDelegate

extension MenuViewController: ImagePickerControllerDelegate {
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
// MARK: - LocationViewControllerDelegate

extension MenuViewController: LocationViewControllerDelegate {
    
    func finishSelectLocation(_ province: Province,
                              _ district: District,
                              _ ward: Ward) {
        self.checkChangeEdit()
        self.userShop.province = province
        self.userShop.district = district
        self.userShop.ward = ward
        self.provinceTextField.text = province.name
        self.districtTextField.text = district.name
        self.wardTextField.text     = ward.name
    }
}
