//
//  CreateProductViewController.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 26/05/2021.
//

import UIKit

class CreateProductViewController: BaseViewController {
    
    static let defaultNumberImages = 5

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
        textField.textField.fontSizePlaceholder(text: TextManager.inputProductName.localized(),
                                                size: FontSize.h1.rawValue)
        return textField
    }()
    
    fileprivate lazy var categoryTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.textField.fontSizePlaceholder(text: TextManager.pickCateogry.localized(),
                                                size: FontSize.h1.rawValue)
        textField.titleText = TextManager.cateogry.localized()
        textField.rightTextfieldImage = ImageManager.dropDown
        return textField
    }()
    
    fileprivate lazy var originalPriceTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.textField.fontSizePlaceholder(text: TextManager.inputOriginalPrice.localized(),
                                                size: FontSize.h1.rawValue)
        textField.titleText = TextManager.inputOriginalPrice.localized()
        textField.keyboardType = .numberPad
        return textField
    }()
    
    fileprivate lazy var promotionPriceTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.textField.fontSizePlaceholder(text: TextManager.inputPromotionPrice.localized(),
                                                size: FontSize.h1.rawValue)
        textField.titleText = TextManager.promotionPrice.localized()
        textField.keyboardType = .numberPad
        return textField
    }()
    
    fileprivate lazy var productDetailTextView: BaseTextView = {
        let textview = BaseTextView()
        textview.titleText = TextManager.detailDes
        textview.placeholder = TextManager.inputDetailDes
        return textview
    }()

    fileprivate lazy var guaranteePriceTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.textField.fontSizePlaceholder(text: TextManager.inputGuarantee_Month.localized(),
                                                size: FontSize.h1.rawValue)
        textField.titleText = TextManager.guarantee_Month.localized()
        textField.keyboardType = .numberPad
        return textField
    }()
    
    fileprivate lazy var tradeMarkTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.textField.fontSizePlaceholder(text: TextManager.inputTradeMark.localized(),
                                                size: FontSize.h1.rawValue)
        textField.titleText = TextManager.tradeMark.localized()
        return textField
    }()
    
    fileprivate lazy var originProductTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.textField.fontSizePlaceholder(text: TextManager.origin.localized(),
                                                size: FontSize.h1.rawValue)
        textField.titleText = TextManager.inputOrigin.localized()
        return textField
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
    
    fileprivate lazy var createProductButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.create.localized(), for: .normal)
        button.backgroundColor = UIColor.thirdColor
        button.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        button.layer.masksToBounds = true
        return button
    }()
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = TextManager.plus
        layoutScrollView()
        layoutCenterStackView()
        layoutItemStackView()
        layoutListImageCollectionView()
        layoutCreateProductButton()
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
        centerStackView.addArrangedSubview(originalPriceTextField)
        centerStackView.addArrangedSubview(promotionPriceTextField)
        centerStackView.addArrangedSubview(productDetailTextView)
        centerStackView.addArrangedSubview(guaranteePriceTextField)
        centerStackView.addArrangedSubview(tradeMarkTextField)
        centerStackView.addArrangedSubview(originProductTextField)
        centerStackView.addArrangedSubview(addPhotoTitleLabel)
    }
    
    private func layoutListImageCollectionView() {
        centerStackView.addArrangedSubview(listImageCollectionView)
        listImageCollectionView.snp.makeConstraints { (make) in
            make.height.equalTo(imageCollectionViewHeight)
        }
    }
    
    private func layoutCreateProductButton() {
        centerStackView.addArrangedSubview(createProductButton)
        createProductButton.snp.makeConstraints { (make) in
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
        return cell
    }
}

extension CreateProductViewController: UICollectionViewDelegate {
    
}

// MARK: - UploadImageCollectionViewCellDelegate

extension CreateProductViewController: UploadImageCollectionViewCellDelegate {
    func didSelectDeleteButton(cell: UploadImageCollectionViewCell, at inexPath: IndexPath) {
    }
}
