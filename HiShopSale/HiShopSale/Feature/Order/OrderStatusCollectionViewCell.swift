//
//  OrderStatusCollectionViewCell.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 01/07/2021.
//

import UIKit

protocol OrderStatusCollectionViewCellDelegate: AnyObject {
    func handleTapOrderDetail(order: Order)
    func handleProcessOrder(order: Order)
}

class OrderStatusCollectionViewCell: BaseCollectionViewCell {
    
    let widthButton = ( ScreenSize.SCREEN_WIDTH -
                            dimension.normalMargin * 2 -
                            dimension.mediumMargin ) / 2
    
    fileprivate lazy var statusTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.second
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .semibold)
        return label
    }()
    
    fileprivate lazy var orderTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .semibold)
        return label
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    fileprivate lazy var coverViewImage: BaseView = {
        let view = BaseView()
        view.layer.cornerRadius = dimension.cornerRadiusSmall
        view.layer.borderWidth  = 1
        view.layer.borderColor  = UIColor.separator.cgColor
        view.layer.masksToBounds = true
        return view
    }()
    
    fileprivate lazy var productImageView: ShimmerImageView = {
        let imageView = ShimmerImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius  = dimension.cornerRadiusSmall
        return imageView
    }()
    
    fileprivate var productNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .semibold)
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    fileprivate var productPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightBodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue,
                                       weight: .medium)
        return label
    }()
    
    fileprivate lazy var firstButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.viewDetail, for: .normal)
        button.titleLabel?.font =
            UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.thirdColor, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.isUserInteractionEnabled = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.thirdColor.cgColor
        button.addTarget(self, action: #selector(tapFirstButton), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var  secondButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.orderPack, for: .normal)
        button.titleLabel?.font =
            UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.primary, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.isUserInteractionEnabled = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.primary.cgColor
        button.addTarget(self, action: #selector(tapSecondButton), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: OrderStatusCollectionViewCellDelegate?
    private (set) var order = Order()
    
    override func initialize() {
        super.initialize()
        layoutStatusTitleLabel()
        layoutOrderTitleLabel()
        layoutLineView()
        layoutCoverView()
        layoutProductImageView()
        layoutProductNameLabel()
        layoutProductPriceLabel()
        layoutFirstButton()
        layoutSecondButton()
        self.secondButton.isHidden = true
    }
    
    @objc private func tapFirstButton() {
        self.delegate?.handleTapOrderDetail(order: order)
    }
    
    @objc private func tapSecondButton() {
        self.delegate?.handleProcessOrder(order: order)
    }
    
    func configCell(order: Order) {
        self.secondButton.isHidden = !(order.status == .process)
        self.order = order
        self.productImageView.loadImage(by: order.photo,
                                        defaultImage: ImageManager.white_backround)
        self.productNameLabel.text  = order.name
        self.productPriceLabel.text = order.bill
        self.statusTitleLabel.text  = order.status.name
        self.orderTitleLabel.text   = "App\(order.orderCode)"
    }
    
    private func layoutStatusTitleLabel() {
        addSubview(statusTitleLabel)
        statusTitleLabel.snp.makeConstraints { (make) in
            make.left
                .equalToSuperview()
                .offset(dimension.normalMargin)
            make.top
                .equalToSuperview()
                .offset(dimension.mediumMargin)
        }
    }
    
    private func layoutOrderTitleLabel() {
        addSubview(orderTitleLabel)
        orderTitleLabel.snp.makeConstraints { (make) in
            make.right
                .equalToSuperview()
                .offset(-dimension.normalMargin)
            make.top
                .equalToSuperview()
                .offset(dimension.mediumMargin)
        }
    }
    
    private func layoutLineView() {
        addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left
                .right
                .equalToSuperview()
                .inset(dimension.normalMargin)
            make.top
                .equalTo(statusTitleLabel.snp.bottom)
                .offset(dimension.mediumMargin)
            make.height
                .equalTo(1)
        }
    }
    
    private func layoutCoverView() {
        addSubview(coverViewImage)
        coverViewImage.snp.makeConstraints { (make) in
            make.left
                .equalTo(lineView)
            make.width
                .height
                .equalTo(80)
            make.top
                .equalTo(lineView.snp.bottom)
                .offset(dimension.mediumMargin)
        }
    }
    
    private func layoutProductImageView() {
        coverViewImage.addSubview(productImageView)
        productImageView.snp.makeConstraints { (make) in
            make.centerX
                .centerY
                .equalToSuperview()
            make.width
                .height
                .equalTo(60)
        }
    }
    
    private func layoutProductNameLabel() {
        addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { (make) in
            make.top
                .equalTo(productImageView)
                .offset(dimension.mediumMargin)
            make.left
                .equalTo(productImageView.snp.right)
                .offset(dimension.largeMargin)
            make.right
                .equalToSuperview()
                .inset(dimension.largeMargin)
        }
    }
    
    private func layoutProductPriceLabel() {
        addSubview(productPriceLabel)
        productPriceLabel.snp.makeConstraints { (make) in
            make.left
                .equalTo(productNameLabel)
            make.top
                .equalTo(productNameLabel.snp.bottom)
                .offset(dimension.mediumMargin)
            make.right
                .equalTo(productNameLabel)
        }
    }
    
    private func layoutFirstButton() {
        contentView.addSubview(firstButton)
        firstButton.snp.makeConstraints { (make) in
            make.top
                .equalTo(coverViewImage.snp.bottom)
                .offset(dimension.normalMargin)
            make.height
                .equalTo(40)
            make.left
                .equalToSuperview()
                .offset(dimension.normalMargin)
            make.width
                .equalTo(widthButton)
        }
    }
    
    private func layoutSecondButton() {
        contentView.addSubview(secondButton)
        secondButton.snp.makeConstraints { (make) in
            make.top
                .equalTo(firstButton)
            make.height
                .equalTo(firstButton)
            make.right
                .equalToSuperview()
                .inset(dimension.normalMargin)
            make.width
                .equalTo(widthButton)
        }
    }
}
