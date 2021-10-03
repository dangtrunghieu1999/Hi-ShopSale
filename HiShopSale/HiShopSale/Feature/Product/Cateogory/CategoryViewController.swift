//
//  CategoryViewController.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 03/07/2021.
//

import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
    func completeSelctCategory(_ category: String,
                               _ subCategory: String,
                               idCategory: Int)
}

class CategoryViewController: BaseViewController {

    
    private lazy var viewControllerFrame = CGRect(x: 0,
                                                  y: 0,
                                                  width: view.bounds.width,
                                                  height: view.bounds.height)
    fileprivate let subCategoryVC = SubCateogryViewController()
    fileprivate let supCategoryVC = SupCategoryViewController()
    private var category    = ""
    private var subCategory = ""
    weak var delegate: CategoryViewControllerDelegate?
    
    var parameters: [CAPSPageMenuOption] = [
        .centerMenuItems(true),
        .scrollMenuBackgroundColor(UIColor.white),
        .selectionIndicatorColor(UIColor.second),
        .selectedMenuItemLabelColor(UIColor.bodyText),
        .menuItemFont(UIFont.systemFont(ofSize: FontSize.h2.rawValue, weight: .medium)),
        .menuHeight(42),
        .bottomMenuHairlineColor(UIColor.separator)
    ]
    
    var pageMenu : CAPSPageMenu?
    fileprivate var subPageControllers: [AbstractLocationViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Danh mục"
        addChildsVC() 
    }
    
    fileprivate func addChildsVC() {
        addSupCateogryVC()
        addSubCategoryVC()
        pageMenu = CAPSPageMenu(viewControllers: subPageControllers,
                                frame: CGRect(x: 0.0, y: self.topbarHeight,
                                width: self.view.frame.width,
                                height: self.view.frame.height),
                                pageMenuOptions: parameters)
        self.view.addSubview(pageMenu!.view)
    }
    
    private func addSupCateogryVC() {
        supCategoryVC.delegate = self
        supCategoryVC.title = TextManager.supCateogry
        supCategoryVC.view.frame = viewControllerFrame
        subPageControllers.append(supCategoryVC)
    }
    
    private func addSubCategoryVC() {
        subCategoryVC.delegate = self
        subCategoryVC.title = TextManager.subCateogry
        subCategoryVC.view.frame = viewControllerFrame
        subPageControllers.append(subCategoryVC)
    }
    
}

extension CategoryViewController: SupCategoryViewControllerDelegate {
    func tapSelectSubCategories(_ categories: [Categories], with title: String) {
        self.category = title
        self.subCategoryVC.configCell(categories)
        self.pageMenu?.moveToPage(1)
    }
}

extension CategoryViewController: SubCateogryViewControllerDelegate {
    func tapSelectComplete(title: String, id: Int) {
        self.subCategory = title
        self.navigationController?.popViewControllerWithHandler(completion: {
            self.delegate?.completeSelctCategory(self.category,
                                                 self.subCategory,
                                                 idCategory: id)
        })
    }
}
