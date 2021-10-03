//
//  ManagerOrderViewController.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 26/05/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

class ManagerOrderViewController: BaseViewController {
    
    // MARK: - Variables
    
    private lazy var viewControllerFrame = CGRect(x: 0,
                                                  y: 0,
                                                  width: view.bounds.width,
                                                  height: view.bounds.height)
    
    var parameters: [CAPSPageMenuOptionB] = [
        .centerMenuItems(true),
        .scrollMenuBackgroundColor(UIColor.white),
        .selectionIndicatorColor(UIColor.second),
        .selectedMenuItemLabelColor(UIColor.second),
        .menuItemFont(UIFont.systemFont(ofSize: FontSize.h2.rawValue, weight: .medium)),
        .menuHeight(65),
    ]
    
    var order: [Order] = []
    var pageMenu : CAPSPageMenuB?
    var numberIndex = 0
    fileprivate var subPageControllers: [AbstractOrderViewController] = []
    
    
    // MARK: - UI Elements
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addBackButtonIfNeeded()
    }
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TextManager.myOrdered
        addGuestChildsVC()
        pageMenu?.moveToPage(numberIndex)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleOrderCancel),
                                               name:  NSNotification.Name.reloadNotifications,
                                               object: nil)
    }
    
    // MARK: - Helper Method
    
    @objc private func handleOrderCancel() {
        self.requestAPIOrder()
    }
    
    fileprivate func addGuestChildsVC() {
        createSubViewOrderManager()
        
        pageMenu = CAPSPageMenuB(viewControllers: subPageControllers,
                                frame: CGRect(x: 0.0, y: self.topbarHeight,
                                width: self.view.frame.width,
                                height: self.view.frame.height),
                                pageMenuOptions: parameters)
        self.view.addSubview(pageMenu!.view)
        requestAPIOrder()
    }
    
    func requestAPIOrder() {
        let endPoint = ProductEndPoint.getAllOrder
        APIService.request(endPoint: endPoint) { [weak self] apiResponse in
            guard let self = self else { return }
            self.order = apiResponse.toArray([Order.self])
            self.reloadAllChildOrderVC(with: self.order)
        } onFailure: { error in
        } onRequestFail: {

        }
    }
    
    func createSubViewOrderManager() {
        for status in Order.arraySubVC {
            let vc = AbstractOrderViewController(status: status)
            vc.view.frame = viewControllerFrame
            vc.title = status.title
            vc.delegate = self
            subPageControllers.append(vc)
        }
    }
    
    private func reloadAllChildOrderVC(with orders: [Order]) {
        for vc in subPageControllers {
            let currentOrders = filterOrders(orders, by: vc.status)
            vc.reloadData(currentOrders)
        }
    }
    
    func filterOrders(_ order: [Order], by status: OrderStatus) -> [Order] {
        switch status {
        case .process, .transport, .success, .canccel:
            return order.filter { $0.status == status }
        case .all:
            return order
        }
    }
}

extension ManagerOrderViewController: AbstractOrderViewControllerDelegate {
    
    func handleUpdateStatus() {
        self.requestAPIOrder()
    }
}
