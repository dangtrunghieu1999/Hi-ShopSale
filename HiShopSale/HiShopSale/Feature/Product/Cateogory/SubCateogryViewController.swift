//
//  SubCateogryViewController.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 03/07/2021.
//

import UIKit

protocol SubCateogryViewControllerDelegate: AnyObject {
    func tapSelectComplete(title: String, id: Int)
}

class SubCateogryViewController: AbstractLocationViewController {

    var categories: [Categories] = []
    weak var delegate: SubCateogryViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
    }
    
    func configCell(_ categories: [Categories]) {
        self.categories = categories
        self.tableView.reloadData()
    }
    
}

extension SubCateogryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LocationsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configCell(title: categories[indexPath.row].name ?? "")
        return cell
    }
    
}

extension SubCateogryViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let title = categories[indexPath.row].name else { return }
        guard let id = categories[indexPath.row].uuid else { return }
        AlertManager.shared.showToast(message: title)
        self.delegate?.tapSelectComplete(title: title, id: id)
    }
}
