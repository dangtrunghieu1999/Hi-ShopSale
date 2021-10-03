//
//  SupCategoryViewController.swift
//  
//
//  Created by Bee_MacPro on 03/07/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol SupCategoryViewControllerDelegate: class {
    func tapSelectSubCategories(_ categories: [Categories], with title: String)
}

class SupCategoryViewController: AbstractLocationViewController {

    fileprivate lazy var categories: [Categories] = []
    weak var delegate: SupCategoryViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        requestAPICategory()
    }
    
    func requestAPICategory() {
        if !isRequestingAPI {
            self.showLoading()
        }
        let path = "http://www.hi-shop.xyz/user-server/category"
        guard let url  = URL(string: path) else { return }
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case.success(let value):
                let json = JSON(value)
                let data = json["data"]
                self.categories = data.arrayValue.map{ Categories(json: $0)}
                self.reloadDataWhenFinishLoadAPI()
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension SupCategoryViewController {
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        guard let title = categories[indexPath.row].name else { return }
        let subCategories = categories[indexPath.row].subCategories
        AlertManager.shared.showToast(message: title)
        delegate?.tapSelectSubCategories(subCategories, with: title)
    }
}

extension SupCategoryViewController: UITableViewDataSource {
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
