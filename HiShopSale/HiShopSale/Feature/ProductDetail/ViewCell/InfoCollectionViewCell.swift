//
//  ProductDetailInfoCollectionViewCell.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/13/21.
//

import UIKit
import FSPagerView
import HCSStarRatingView

protocol InfoCollectionViewCellDelegate: AnyObject {
    func handleDeleteProduct()
    func handleSettingProduct()
}

class InfoCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables
    var product: Product?
    var photos: [Photo]? = []
    var selectedLike: Bool = true
    weak var delegate: InfoCollectionViewCellDelegate?
    
    // MARK: - UI Elements
    
    fileprivate lazy var pageView: FSPagerView = {
        let view = FSPagerView()
        view.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        view.itemSize = FSPagerView.automaticSize
        view.transformer = FSPagerViewTransformer(type: .overlap)
        view.isInfinite = true
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    fileprivate lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.backgroundColor = UIColor.grayBoder
        label.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        return label
    }()
    
    fileprivate lazy var codeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.textAlignment = .left
        label.layer.masksToBounds = true
        label.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        return label
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .semibold)
        return label
    }()
    
    fileprivate lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.icon_delete,
                        for: .normal)
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(tapOnDelete),
                         for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var updateButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.icon_update,
                        for: .normal)
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(tapOnUpdate),
                         for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var ratingView: HCSStarRatingView = {
        let ratingView = HCSStarRatingView()
        ratingView.tintColor = UIColor.ratingColor
        ratingView.allowsHalfStars = true
        ratingView.isUserInteractionEnabled = false
        return ratingView
    }()
    
    fileprivate lazy var numberReviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        return label
    }()
    
    fileprivate lazy var promotionPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.title.rawValue,
                                       weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var originalPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.layer.cornerRadius = 5
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        return label
    }()
    
    fileprivate lazy var promotionPercentLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.layer.cornerRadius = 5
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        return label
    }()
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutPageView()
        layoutNumberLabel()
        layoutCodeLabel()
        layoutDeleteButton()
        layoutUpdateButton()
        layoutTitleLabel()
        layoutRatingView()
        layoutNumberReviewLabel()
        layoutPromotionPriceLabel()
        layoutOriginalPriceLabel()
        layoutPromotionPercentLabel()
    }
    
    // MARK: - Helper Method
    
    static func estimateHeight(_ product: Product) -> CGFloat {
        let nameHeight = product.name.height(
            withConstrainedWidth: ScreenSize.SCREEN_WIDTH - 2 * Dimension.shared.normalMargin,
            font: UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .semibold))
        
        return ScreenSize.SCREEN_WIDTH + nameHeight + 140
    }
    
    @objc private func tapOnDelete() {
        self.delegate?.handleDeleteProduct()
    }
    
    @objc private func tapOnUpdate() {
        self.delegate?.handleSettingProduct()
    }
    
    func configDataInfomation(product: Product?) {
        self.product = product
        self.photos = product?.photos
        self.numberLabel.text = "1/\(product?.photos.count ?? 0)"
        let productName = product?.name ?? ""
        self.titleLabel.attributedText = Ultilities.lineSpacingLabel(title: productName)
        self.codeLabel.text = "#\(product?.code ?? "")"
        self.ratingView.value = CGFloat(product?.totalStar ?? 0)
        self.numberReviewLabel.text = ""
        self.promotionPriceLabel.text = product?.priceSale.currencyFormat
        let originalPrice = product?.price
        self.originalPriceLabel.attributedText = Ultilities.drawLineBetween(price: originalPrice)
        let promotionPercent = product?.sale ?? 0
        self.promotionPercentLabel.text = "-\(promotionPercent)%"
        self.pageView.reloadData()
    }
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutPageView() {
        addSubview(pageView)
        pageView.snp.makeConstraints { (make) in
            make.width.centerX.top.equalToSuperview()
            make.height.equalTo(ScreenSize.SCREEN_WIDTH)
        }
    }
    
    private func layoutNumberLabel() {
        addSubview(numberLabel)
        numberLabel.snp.makeConstraints { (make) in
            make.top.equalTo(pageView.snp.bottom)
                .offset(dimension.mediumMargin)
            make.width.equalTo(35)
            make.right.equalToSuperview()
                .offset(-dimension.normalMargin)
            make.height.equalTo(20)
        }
    }
    
    private func layoutCodeLabel() {
        addSubview(codeLabel)
        codeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(pageView.snp.bottom)
                .offset(dimension.mediumMargin)
            make.width.equalTo(100)
            make.left.equalToSuperview()
                .offset(dimension.normalMargin)
        }
    }
    private func layoutDeleteButton() {
        addSubview(deleteButton)
        deleteButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(24)
            make.right.equalTo(numberLabel.snp.left)
                .offset(-dimension.normalMargin)
            make.top.equalTo(numberLabel)
        }
    }
    
    private func layoutUpdateButton() {
        addSubview(updateButton)
        updateButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(28)
            make.right.equalTo(deleteButton.snp.left)
                .offset(-dimension.normalMargin)
            make.top.equalTo(numberLabel)
        }
    }
    
    private func layoutTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
                .offset(dimension.normalMargin)
            make.right.equalToSuperview()
                .offset(-dimension.normalMargin)
            make.top.equalTo(numberLabel.snp.bottom)
                .offset(dimension.mediumMargin)
        }
    }
    
    private func layoutRatingView() {
        addSubview(ratingView)
        ratingView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
    }
    
    private func layoutNumberReviewLabel() {
        addSubview(numberReviewLabel)
        numberReviewLabel.snp.makeConstraints { (make) in
            make.left.equalTo(ratingView.snp.right)
                .offset(dimension.mediumMargin)
            make.top.equalTo(ratingView)
            make.centerY.equalTo(ratingView)
        }
    }
    
    private func layoutPromotionPriceLabel() {
        addSubview(promotionPriceLabel)
        promotionPriceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(ratingView.snp.bottom)
                .offset(dimension.smallMargin)
            make.bottom.equalToSuperview()
                .offset(-dimension.normalMargin)
        }
    }
    
    private func layoutOriginalPriceLabel() {
        addSubview(originalPriceLabel)
        originalPriceLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(promotionPriceLabel)
            make.left.equalTo(promotionPriceLabel.snp.right)
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutPromotionPercentLabel() {
        addSubview(promotionPercentLabel)
        promotionPercentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(originalPriceLabel.snp.right)
                .offset(dimension.mediumMargin)
            make.bottom.equalTo(originalPriceLabel)
        }
    }
}

// MARK: - FSPagerViewDataSource

extension InfoCollectionViewCell: FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return photos?.count ?? 0
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let imageURL = photos?[index].link
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.sd_setImage(with: imageURL?.url, completed: nil)
        cell.imageView?.contentMode = .scaleToFill
        cell.imageView?.clipsToBounds = true
        return cell
    }
}

// MARK: - FSPagerViewDelegate

extension InfoCollectionViewCell: FSPagerViewDelegate {
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.numberLabel.text = "\(targetIndex + 1)/\(product?.photos.count ?? 0)"
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.numberLabel.text = "\(pagerView.currentIndex)/\(product?.photos.count ?? 0)"
    }
}
