//
//  MenuViewController.swift
//  HiShopSale
//
//  Created by Dang Trung Hieu on 5/12/21.
//

import UIKit

class MenuViewController: BaseViewController {

    // MARK: - Variables
    
    var isSlideInMenuPresented  = false
    lazy var slideInMenuPadding: CGFloat = self.view.frame.width * 0.30
    
    // MARK: - UI Elements
    
    fileprivate lazy var menuView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.second
        return view
    }()
    
    fileprivate lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.second
        tableView.showsVerticalScrollIndicator = false
        tableView.registerReusableCell(MenuTableViewCell.self)
        return tableView
    }()
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TextManager.menuShop
        self.setLeftNavigationBar(ImageManager.icon_menu)
        self.menuView.pintoMenu(view, with: slideInMenuPadding)
        self.containerView.edgeTo(view)
        self.layoutTableView()
    }
    
    override func touchUpInLeftBarButtonItem() {
        UIView.animate(withDuration: 0.5, delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut) {
            self.containerView.frame.origin.x =
                self.isSlideInMenuPresented ? 0 : self.containerView.frame.width - self.slideInMenuPadding
        } completion: { (finished) in
            print("Animate finished: \(finished)")
            self.isSlideInMenuPresented.toggle()
        }

    }
    
    // MARK: - Ovveride Method
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Helper Method
    
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutTableView() {
        menuView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MenuTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.backgroundColor = UIColor.second
        return cell
    }
}


