//
//  CreateProductViewController.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 26/05/2021.
//

import UIKit
import Photos

class CreateProductViewController: BaseViewController {
    
    static let defaultNumberImages = 5
    var product = Product()
    var numberHorizontalItem: CGFloat {
        var numberHorizontalItem: CGFloat = 2
        let ip6Width: CGFloat = 375
        let ipadAirWidth: CGFloat = 768
        
        if ScreenSize.SCREEN_WIDTH >= ipadAirWidth {
            numberHorizontalItem = 6
        } else if ScreenSize.SCREEN_WIDTH > ip6Width {
            numberHorizontalItem = 3
        }
        
        return numberHorizontalItem
    }
    
    fileprivate var defaultProductImageWidth: CGFloat {
        return (ScreenSize.SCREEN_WIDTH - 2 * Dimension.shared.normalMargin ) / numberHorizontalItem
    }
    
    fileprivate var imageCollectionViewHeight: CGFloat {
        let verticalItem = ceil(CGFloat(CreateProductViewController.defaultNumberImages) / numberHorizontalItem)
        return defaultProductImageWidth * verticalItem
    }

    // MARK: - UI ELements
    
    let centerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis         = .vertical
        stackView.alignment    = .fill
        stackView.distribution = .fill
        stackView.spacing = dimension.normalMargin
        return stackView
    }()

    fileprivate lazy var productNameTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText   = TextManager.productName.localized()
        textField.textField.fontPlaceholder(text: TextManager.inputProductName.localized(),
                                                size: FontSize.h1.rawValue)
        textField.boderColor = UIColor.second
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var categoryTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.textField.fontPlaceholder(text: TextManager.pickCateogry.localized(),
                                                size: FontSize.h1.rawValue)
        textField.titleText = TextManager.cateogry.localized()
        textField.rightTextfieldImage = ImageManager.dropDown
        textField.addTarget(self, action:#selector(textFieldBeginEditing(_:)),
                            for: .editingDidBegin)
        textField.boderColor = UIColor.second
        return textField
    }()
    
    fileprivate lazy var subCategoryTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.textField.fontPlaceholder(text: TextManager.subPickCateogry.localized(),
                                                size: FontSize.h1.rawValue)
        textField.titleText = TextManager.cateogry.localized()
        textField.rightTextfieldImage = ImageManager.dropDown
        textField.addTarget(self, action:#selector(textFieldBeginEditing(_:)),
                            for: .editingDidBegin)
        textField.boderColor = UIColor.second
        return textField
    }()
    
    let priceView = UIView()
    
    fileprivate lazy var originalPriceTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.textField.fontPlaceholder(text: TextManager.inputOriginalPrice.localized(),
                                                size: FontSize.h1.rawValue)
        textField.titleText = TextManager.inputOriginalPrice.localized()
        textField.boderColor = UIColor.second
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var promotionPriceTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.textField.fontPlaceholder(text: TextManager.promotionPrice.localized(),
                                                size: FontSize.h1.rawValue)
        textField.titleText = TextManager.promotionPrice.localized()
        textField.boderColor = UIColor.second
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        return textField
    }()
    
    
    let paramView = UIView()
    
    fileprivate lazy var weightProductTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.textField.fontPlaceholder(text: TextManager.inputWeight.localized(),
                                                size: FontSize.h1.rawValue)
        textField.titleText = TextManager.weight.localized()
        textField.boderColor = UIColor.second
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var quantityProductTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.textField.fontPlaceholder(text: TextManager.inputQuantity.localized(),
                                                size: FontSize.h1.rawValue)
        textField.titleText = TextManager.quantity.localized()
        textField.boderColor = UIColor.second
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        return textField
    }()

    fileprivate lazy var productDetailTextView: BaseTextView = {
        let textview = BaseTextView()
        textview.titleText = TextManager.detailDes
        textview.placeholder = TextManager.inputDetailDes
        textview.boderColor = UIColor.second
        textview.addressTextView.delegate = self
        return textview
    }()
    
    fileprivate lazy var addPhotoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.addPhoto.localized()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .semibold)
        return label
    }()

    fileprivate lazy var listImageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: defaultProductImageWidth, height: defaultProductImageWidth)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerReusableCell(UploadImageCollectionViewCell.self)
        return collectionView
    }()
    
    fileprivate lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.next.localized(), for: .normal)
        button.backgroundColor = UIColor.disable
        button.setTitleColor(UIColor.bodyText, for: .normal)
        button.layer.cornerRadius = dimension.cornerRadiusSmall
        button.layer.masksToBounds = true
        button.isUserInteractionEnabled = false
        button.addTarget(self, action: #selector(tapOnNext), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = TextManager.plus
        layoutScrollView()
        layoutCenterStackView()
        layoutItemStackView()
        layoutPriceView()
        layoutOriginalPriceTextField()
        layoutPromotionPriceTextField()
        layoutParamView()
        layoutParamViewItem()
        layoutBottomItemView()
        layoutListImageCollectionView()
        layoutCreateProductButton()
    }
    
    @objc private func textFieldValueChange(_ textField: UITextField) {
        checkCanEnableNextButton()
    }

    
    private func checkCanEnableNextButton() {
        guard let productName = productNameTextField.text,
              let supCategory = categoryTextField.text,
              let subCateogry = subCategoryTextField.text,
              let price       = originalPriceTextField.text,
              let priceSale   = promotionPriceTextField.text,
              let quantity    = quantityProductTextField.text,
              let weight      = weightProductTextField.text,
              let descriptions = productDetailTextView.addressTextView.text
        else {
            return
        }
        
        if productName != ""
            && subCateogry != ""
            && supCategory != ""
            && price != ""
            && priceSale != ""
            && descriptions != ""
            && weight != ""
            && quantity != ""
            && !product.photos.isEmpty{
        
            self.product.name = productName
            self.product.price = Double(price) ?? 0
            self.product.priceSale = Double(priceSale) ?? 0
            self.product.descriptions = descriptions
            self.product.avaiable = Int(quantity) ?? 0
            self.product.weight = Double(weight) ?? 0
            
            nextButton.isUserInteractionEnabled = true
            nextButton.setTitleColor(UIColor.white, for: .normal)
            nextButton.backgroundColor = UIColor.thirdColor
        } else {
            nextButton.isUserInteractionEnabled = false
            nextButton.setTitleColor(UIColor.bodyText, for: .normal)
            nextButton.backgroundColor = UIColor.disable
        }
    }
    
    
    @objc private func textFieldBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        let vc = CategoryViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
     
    @objc private func tapOnNext() {
        let vc = DetailsViewController(product)
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func layoutCenterStackView() {
        scrollView.addSubview(centerStackView)
        centerStackView.snp.makeConstraints { (make) in
            make.left.equalTo(view)
                .offset(dimension.normalMargin)
            make.right.equalTo(view)
                .offset(-dimension.normalMargin)
            make.bottom.equalToSuperview()
                .offset(-Dimension.shared.largeMargin)
            make.top.equalToSuperview()
                .offset(Dimension.shared.largeMargin)
        }
    }
    
    private func layoutItemStackView() {
        centerStackView.addArrangedSubview(productNameTextField)
        centerStackView.addArrangedSubview(categoryTextField)
        centerStackView.addArrangedSubview(subCategoryTextField)
    }
    
    private func layoutPriceView() {
        centerStackView.addArrangedSubview(priceView)
    }
    
    private func layoutOriginalPriceTextField() {
        priceView.addSubview(originalPriceTextField)
        originalPriceTextField.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.trailing.equalTo(priceView.snp.centerX)
                .offset(-dimension.mediumMargin)
        }
    }
    
    private func layoutPromotionPriceTextField() {
        priceView.addSubview((promotionPriceTextField))
        promotionPriceTextField.snp.makeConstraints { (make) in
            make.trailing.top.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.leading.equalTo(priceView.snp.centerX)
                .offset(dimension.mediumMargin)
        }
    }
    
    private func layoutParamView() {
        centerStackView.addArrangedSubview(paramView)
    }
    
    private func layoutParamViewItem() {
        paramView.addSubview(weightProductTextField)
        weightProductTextField.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.trailing.equalTo(paramView.snp.centerX)
                .offset(-dimension.mediumMargin)
        }
        
        paramView.addSubview((quantityProductTextField))
        quantityProductTextField.snp.makeConstraints { (make) in
            make.trailing.top.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.leading.equalTo(paramView.snp.centerX)
                .offset(dimension.mediumMargin)
        }
    }
    
    private func layoutBottomItemView() {
        centerStackView.addArrangedSubview(productDetailTextView)
        centerStackView.addArrangedSubview(addPhotoTitleLabel)
    }
    
    private func layoutListImageCollectionView() {
        centerStackView.addArrangedSubview(listImageCollectionView)
        listImageCollectionView.snp.makeConstraints { (make) in
            make.height.equalTo(imageCollectionViewHeight)
        }
    }
    
    private func layoutCreateProductButton() {
        centerStackView.addArrangedSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.height.equalTo(Dimension.shared.largeHeightButton)
        }
    }
}

extension CreateProductViewController: UICollectionViewDelegateFlowLayout {
    
}

extension CreateProductViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CreateProductViewController.defaultNumberImages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UploadImageCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.indexPath = indexPath
        cell.delegate = self
        cell.setPhoto(photo: product.photos[safe: indexPath.row])
        return cell
    }
}

extension CreateProductViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let maxSelectImage = CreateProductViewController.defaultNumberImages - product.photos.count
        if maxSelectImage <= 0 {
            AlertManager.shared.show(message: TextManager.selectMaxPhotoAddProduct.localized())
            return
        }
        AppRouter.presentToImagePicker(pickerDelegate: self, limitImage: maxSelectImage)
    }
}

// MARK: - UploadImageCollectionViewCellDelegate

extension CreateProductViewController: UploadImageCollectionViewCellDelegate {
    func didSelectDeleteButton(cell: UploadImageCollectionViewCell, at inexPath: IndexPath) {
        product.removePhoto(at: inexPath.row)
        listImageCollectionView.reloadData()
        checkCanEnableNextButton()
    }
}

// MARK: - ImagePickerControllerDelegate

extension CreateProductViewController: ImagePickerControllerDelegate {
    func imagePickerController(_ picker: ImagePickerController,
                               shouldLaunchCameraWithAuthorization status: AVAuthorizationStatus) -> Bool {
        return true
    }
    
    func imagePickerController(_ picker: ImagePickerController,
                               didFinishPickingImageAssets assets: [PHAsset]) {
        dismiss(animated: true, completion: nil)
        var photos: [Photo] = Array(repeating: Photo(), count: assets.count)
        let dispatchGroup = DispatchGroup()
        
        DispatchQueue.global(qos: .userInteractive).async {
            for (index, asset) in assets.enumerated() {
                dispatchGroup.enter()
                asset.getUIImage(completion: { (image) in
                    if let image = image, index < photos.count {
                        photos[index] = Photo(image: image.normalizeImage())
                    }
                    dispatchGroup.leave()
                })
            }
            
            let result = dispatchGroup.wait(timeout: .now() + .seconds(5));
            if result == .success {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.product.addNewPhoto(photos: photos)
                    self.listImageCollectionView.reloadData()
                    self.checkCanEnableNextButton()
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: ImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension CreateProductViewController: CategoryViewControllerDelegate {
    func completeSelctCategory(_ category: String,
                               _ subCategory: String,
                               idCategory: Int) {
        self.categoryTextField.text    = category
        self.subCategoryTextField.text = subCategory
        self.product.categoryId        = idCategory
        self.product.detail            = category + ";"
    }
}

// MARK: - UITextViewDelegate

extension CreateProductViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == TextManager.inputDetailDes.localized() {
            textView.text = ""
        }
        
        textView.textColor = UIColor.titleText
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = TextManager.inputDetailDes.localized()
            textView.textColor = UIColor.placeholder
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        checkCanEnableNextButton()
    }
}

// MARK: - DetailsViewControllerDelegate

extension CreateProductViewController: DetailsViewControllerDelegate {
    func completeCreateProduct() {
        AlertManager.shared.showToast(message: "Thêm sản phẩm mới thành công")
        self.productNameTextField.text = ""
        self.categoryTextField.text = ""
        self.subCategoryTextField.text = ""
        self.originalPriceTextField.text = ""
        self.promotionPriceTextField.text = ""
        self.quantityProductTextField.text = ""
        self.weightProductTextField.text = ""
        self.productDetailTextView.addressTextView.text = ""
        self.product.photos.removeAll()
        self.listImageCollectionView.reloadData()
    }
}
