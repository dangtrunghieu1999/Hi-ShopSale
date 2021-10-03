//
//  NotificationViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/8/21.
//

import UIKit
import SwiftyJSON
import Alamofire

class NotificationViewController: BaseViewController {
    
    // MARK: - Variables
    
    // MARK: - UI Elements
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.lightBackground
        tableView.showsVerticalScrollIndicator = false
        tableView.registerReusableCell(NotificationsTableViewCell.self)
        tableView.registerReusableCell(EmptyTableViewCell.self)
        return tableView
    }()
    
    private var notifications: [Notifications] = []
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TextManager.notification
        layoutTableView()
        checkLogginUser()
    }
    
    // MARK: - Helper Method
    
    // MARK: - GET API
    
    private func checkLogginUser() {
        if UserManager.isLoggedIn() {
            self.getAPINotification()
        } else {
            let vc = SignInViewController()
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    private func getAPINotification() {
        let params: [String: Any] = ["pageNumber": 0,
                                     "pageSize": 20]
        let endPoint = UserShopEndPoint.getNotifications(params: params)

        APIService.request(endPoint: endPoint) { [weak self] apiResponse in
            guard let self = self else { return }
            let json       = apiResponse.data?["content"]
            self.notifications = json?.arrayValue.map { Notifications(json: $0)} ?? []
            self.tableView.reloadData()
        } onFailure: { error in
            self.hideLoading()
            AlertManager.shared.showToast()
        } onRequestFail: {
            self.hideLoading()
            AlertManager.shared.showToast()
        }
    }
    
    // MARK: - Layout
    
    private func layoutTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
            }
            make.left.right.bottom.equalToSuperview()
        }
    }
    
}

// MARK: - UITableViewDelegate

extension NotificationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.notifications.isEmpty {
            return 300
        } else {
            return tableView.estimatedRowHeight
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = notifications[indexPath.row]
        if notification.type == 0 {
            let vc = OrderDetailViewController()
            vc.requestAPIOrderDetail(orderId: notification.orderId)
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = ProductDetailViewController()
            let product = Product()
            product.id = notification.productId
            vc.configData(product, isCheck: true)
            vc.scrollCommentProduct()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource

extension NotificationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if notifications.isEmpty {
            return 1
        } else {
            return notifications.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if notifications.isEmpty {
            let cell: EmptyTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.emptyView.image = ImageManager.icon_logo2
            cell.emptyView.message = TextManager.emptyNotification
            cell.emptyView.backgroundColor = UIColor.lightBackground
            return cell
        } else {
            let cell: NotificationsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configCell(notifications[indexPath.row])
            return cell
        }
    }
}
