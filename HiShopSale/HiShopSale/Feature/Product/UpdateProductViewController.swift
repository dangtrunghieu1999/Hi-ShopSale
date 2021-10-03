//
//  UpdateProductViewController.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 30/07/2021.
//

import UIKit
import Photos

protocol UpdateProductViewControllerDelegate: AnyObject {
    func handleSuccessUpdate(product: Product)
}

class UpdateProductViewController: BaseViewController {

    static let defaultNumberImages = 5
    private (set) var product = Product()
    private (set) var photos: [Photo] = []
    weak var delgate: UpdateProductViewControllerDelegate?
    
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
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)),
                            for: .editingChanged)
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
        textField.keyboardType = .decimalPad
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)),
                            for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var promotionPriceTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.textField.fontPlaceholder(text: TextManager.promotionPrice.localized(),
                                                size: FontSize.h1.rawValue)
        textField.titleText = TextManager.promotionPrice.localized()
        textField.boderColor = UIColor.second
        textField.keyboardType = .decimalPad
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)),
                            for: .editingChanged)
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
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .semibold)
        return label
    }()

    fileprivate lazy var listImageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: defaultProductImageWidth,
                                 height: defaultProductImageWidth)
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerReusableCell(UploadImageCollectionViewCell.self)
        return collectionView
    }()
    
    fileprivate lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.save.localized(), for: .normal)
        button.backgroundColor = UIColor.disable
        button.setTitleColor(UIColor.bodyText, for: .normal)
        button.layer.cornerRadius = dimension.cornerRadiusSmall
        button.layer.masksToBounds = true
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(tapOnSave),
                         for: .touchUpInside)
        return button
    }()
    
    convenience init(product: Product) {
        self.init()
        self.product = product
        self.configData()
    }
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = TextManager.editProduct
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
    
    private func configData() {
        self.productNameTextField.text     = product.name
        self.originalPriceTextField.text   = String((Int(product.price)))
        self.promotionPriceTextField.text  = String((Int(product.priceSale)))
        self.weightProductTextField.text   = String(product.weight)
        self.categoryTextField.text        = product.category.name
        self.subCategoryTextField.text     = product.firstSubCategory
        self.quantityProductTextField.text = String(product.avaiable)
        self.productDetailTextView.addressTextView.text = product.descriptions
    }
    
    private func checkCanEnableNextButton() {
        guard let productName = productNameTextField.text,
              let price       = originalPriceTextField.text,
              let priceSale   = promotionPriceTextField.text,
              let avaiable    = quantityProductTextField.text,
              let category    = categoryTextField.text,
              let weight      = weightProductTextField.text,
              let subCategory = subCategoryTextField.text,
              let descriptions = productDetailTextView.addressTextView.text
        else {
            return
        }

        if productName != product.name
            || price != String(product.price)
            || priceSale != String(product.priceSale)
            || avaiable != String(product.avaiable)
            || weight != String(product.weight)
            || category != product.category.name
            || subCategory != product.firstSubCategory
            || product.photos.count > 0 
            || descriptions != product.descriptions {
            saveButton.isUserInteractionEnabled = true
            saveButton.setTitleColor(UIColor.white, for: .normal)
            saveButton.backgroundColor = UIColor.thirdColor
        } else {
            saveButton.isUserInteractionEnabled = false
            saveButton.setTitleColor(UIColor.bodyText, for: .normal)
            saveButton.backgroundColor = UIColor.disable
        }
    }
     
    @objc private func tapOnSave() {
        guard let productName = productNameTextField.text,
              var price       = originalPriceTextField.text,
              var priceSale   = promotionPriceTextField.text,
              let avaiable    = quantityProductTextField.text,
              let weight      = weightProductTextField.text,
              let descriptions = productDetailTextView.addressTextView.text
        else {
            return
        }
        price = price.replacingOccurrences(of: ",", with: "")
        priceSale = priceSale.replacingOccurrences(of: ",", with: "")
        product.name         = productName
        product.price        = price.toDouble()
        product.priceSale    = priceSale.toDouble()
        product.avaiable     = avaiable.toInt()
        product.weight       = weight.toDouble()
        product.descriptions = descriptions
        let endPoint = ProductEndPoint.updateProduct(params: product.toDictionary())
        self.showLoading()
        APIService.request(endPoint: endPoint) { [weak self] apiResponse in
            guard let self = self else { return }
            self.hideLoading()
            self.navigationController?.popViewControllerWithHandler(completion: {
                self.delgate?.handleSuccessUpdate(product: self.product)
            })
        } onFailure: { error in
            self.hideLoading()
        } onRequestFail: {
            self.hideLoading()
        }
    }
    
    @objc private func textFieldBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        let vc = CategoryViewController()
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
        centerStackView.addArrangedSubview(categoryTextField)
        centerStackView.addArrangedSubview(subCategoryTextField)
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
        centerStackView.addArrangedSubview(saveButton)
        saveButton.snp.makeConstraints { (make) in
            make.height.equalTo(Dimension.shared.largeHeightButton)
        }
    }
}

extension UpdateProductViewController: UICollectionViewDelegateFlowLayout {
    
}

extension UpdateProductViewController: UICollectionViewDataSource {
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

extension UpdateProductViewController: UICollectionViewDelegate {
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

extension UpdateProductViewController: UploadImageCollectionViewCellDelegate {
    func didSelectDeleteButton(cell: UploadImageCollectionViewCell, at inexPath: IndexPath) {
        let name = product.photos[inexPath.row].name
        self.product.removePhoto(at: inexPath.row)
        let photo = Photo()
        photo.name = name
        photo.link = ""
        listImageCollectionView.reloadData()
        checkCanEnableNextButton()
        self.product.addNewPhoto(photo: photo)
    }
}

// MARK: - ImagePickerControllerDelegate

extension UpdateProductViewController: ImagePickerControllerDelegate {
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

extension UpdateProductViewController: CategoryViewControllerDelegate {
    func completeSelctCategory(_ subCateogry: String,
                               _ supCategory: String,
                                 idCategory: Int) {
        self.categoryTextField.text    = subCateogry
        self.subCategoryTextField.text = supCategory
        self.product.categoryId        = idCategory
    }
}

// MARK: - UITextViewDelegate

extension UpdateProductViewController: UITextViewDelegate {
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
