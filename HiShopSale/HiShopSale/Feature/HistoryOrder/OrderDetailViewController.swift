//
//  OrderDetailViewController.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 13/08/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

enum OrderDetailType: Int {
    case code       = 0
    case section1
    case address
    case section2
    case info
    case section3
    case transport
    case section4
    case payment
    case section5
    case bill
    case section6
    case cancel
    
    static func numberOfItems() -> Int {
        return 13
    }
}

class OrderDetailViewController: BaseViewController {

    // MARK: - UI Elements
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.separator
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.registerReusableCell(OrderCodeCollectionViewCell.self)
        collectionView.registerReusableCell(BillerCollectionViewCell.self)
        collectionView.registerReusableCell(OrderAddressCollectionViewCell.self)
        collectionView.registerReusableCell(FooterCollectionViewCell.self)
        collectionView.registerReusableCell(OrderDetailInfoCollectionViewCell.self)
        collectionView.registerReusableCell(OrderPaymentCollectionViewCell.self)
        collectionView.registerReusableCell(OrderTransportCollectionViewCell.self)
        collectionView.registerReusableCell(OrderCancelCollectionViewCell.self)
        return collectionView
    }()
    
    private var orderDetail = OrderDetail()
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TextManager.order
        layoutCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showLoading()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.hideLoading()
    }

    // MARK: - Layout
    
    private func layoutCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide)
                
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
            }
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension OrderDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let type  = OrderDetailType(rawValue: indexPath.row)
        switch type {
        case .code:
            return CGSize(width: width,
                          height: 90)
        case .info:
            return CGSize(width: width,
                          height: orderDetail.estimateHeight + 50.0)
        case .address:
            return CGSize(width: width, height: 110)
        case .transport, .payment:
            return CGSize(width: width, height: 74)
        case .section1, .section2, .section3, .section4, .section5, .section6:
            return CGSize(width: width, height: 8)
        case .bill:
            return CGSize(width: width, height: 200)
        case .cancel:
            return CGSize(width: width, height: 80)
        default:
            return CGSize(width: width, height: 0)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension OrderDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if orderDetail.status == 1 {
            return OrderDetailType.numberOfItems()
        } else {
            return 11
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = OrderDetailType(rawValue: indexPath.row)
        switch type {
        case .code:
            let cell: OrderCodeCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configCell(code: orderDetail.orderCode,
                            orderTime: orderDetail.orderTime,
                            deliveryTime: orderDetail.deliveryTime,
                            statusCode: orderDetail.status)
            return cell
        case .info:
            let cell: OrderDetailInfoCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configCell(products: orderDetail.products)
            return cell
        case .address:
            let cell: OrderAddressCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configCell(with: orderDetail.userInfo,
                            addressRecive: orderDetail.address)
            return cell
        case .transport:
            let cell: OrderTransportCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.trasnportTitleLabel.text = orderDetail.transporter
            return cell
        case .payment:
            let cell: OrderPaymentCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            if orderDetail.isPaymentOnline == 1 {
                cell.paymentTitleLabel.text = orderDetail.paymentMethod + " - Đơn hàng đã thanh toán"
            } else {
                cell.paymentTitleLabel.text = orderDetail.paymentMethod
            }
            return cell
        case .section1, .section2, .section3, .section4, .section5, .section6:
            let cell: FooterCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        case .bill:
            let cell: BillerCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configCell(tempMoney: orderDetail.tempMoney,
                            feeShip: orderDetail.feeShip,
                            totalMoney: orderDetail.totalMoney)
            return cell
        case .cancel:
            let cell: OrderCancelCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

 // MARK: - API

extension OrderDetailViewController {
    
    func requestAPIOrderDetail(orderId: Int) {
        let endPoint = ProductEndPoint.getOrderDetail(params: ["id": orderId])
        APIService.request(endPoint: endPoint) { [weak self] apiResponse in
            guard let self = self else { return }
            self.hideLoading()
            self.orderDetail = apiResponse.toObject(OrderDetail.self) ?? OrderDetail()
            self.collectionView.reloadData()
        } onFailure: { erorr in
            self.hideLoading()
        } onRequestFail: {
            self.hideLoading()
        }
    }
}

extension OrderDetailViewController: OrderCancelCollectionViewCellDelegate {
    func handleOrderCancel() {
        let endPoint = ProductEndPoint.cancelOrder(params: ["id": orderDetail.orderId])
        self.showLoading()
        APIService.request(endPoint: endPoint) { [weak self] apiResponse in
            guard let self = self else { return }
            self.hideLoading()
            AlertManager.shared.showToast(message: "Đơn hàng đã huỷ")
            NotificationCenter.default.post(name: Notification.Name.reloadNotifications, object: nil)
        } onFailure: { error in
            self.hideLoading()
        } onRequestFail: {
            self.hideLoading()
        }
    }
}

