//
//  ProductParameterViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/19/21.
//

import UIKit

class ParameterViewController: BaseViewController {
    
    // MARK: - Variables
    
    private var dataKey: [String]   = ["Danh mục","Cung cấp bởi",
                                       "Thương hiệu","Xuất xứ thương hiệu",
                                       "Xuất xứ", "Hướng dẫn",
                                       "Chất liệu","Model",
                                       "Hoá đơn VAT","Bảo hành"]
    
    private var dataValue: [String] = []
    private var productId = 0
    
    // MARK: - UI Elements
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
        tableView.isScrollEnabled = true
        tableView.showsVerticalScrollIndicator = false
        tableView.registerReusableCell(TitleTableViewCell.self)
        return tableView
    }()
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLeftNavigationBar(ImageManager.dismiss_close)
        setRightNavigationBar(ImageManager.icon_update)
        navigationItem.title = TextManager.detailProduct
        layoutTableView()
    }
    
    // MARK: - Helper Method
    
    override func touchUpInLeftBarButtonItem() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchUpInRightBarButtonItem() {
        let vc = UpdateDetailViewController()
        vc.delegate = self
        vc.configData(data: dataValue, productId: productId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Helper Method
    
    func configCell(detail: String,id: Int) {
        self.productId = id
        self.dataValue = detail.components(separatedBy: ";")
        self.tableView.reloadData()
    }
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDelegate

extension ParameterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
}

// MARK: - UITableViewDataSource
extension ParameterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        return dataValue.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TitleTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configTitle(keyTitle: dataKey[indexPath.row],
                         valueTitle: dataValue[indexPath.row])
        if indexPath.row % 2 == 0{
            cell.keyCoverView.backgroundColor = UIColor.lightBackground
            cell.valueCoverView.backgroundColor = UIColor.lightBackground
        } else {
            cell.keyCoverView.backgroundColor = UIColor.white
            cell.valueCoverView.backgroundColor = UIColor.white
        }
        return cell
    }
}

// MARK: - UpdateDetailViewControllerDelegate
extension ParameterViewController: UpdateDetailViewControllerDelegate {
    func handleUpdateSuccess(data: String) {
        self.dataValue = data.components(separatedBy: ";")
        self.tableView.reloadData()
    }
}
