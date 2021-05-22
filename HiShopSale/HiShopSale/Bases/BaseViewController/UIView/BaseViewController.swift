//
//  BaseUIViewController.swift
//  ZoZoApp
//
//  Created by MACOS on 5/30/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import JGProgressHUD

enum BarButtonItemType {
    case left
    case right
}

typealias Target = (target: Any?, selector: Selector)

struct BarButtonItemModel {
    var image: UIImage?
    var title: String?
    var target: Target
    
    init(_ image: UIImage?, _ target: Target) {
        self.image = image
        self.target = target
    }
    
    init(_ image: UIImage? = nil, _ title: String? = nil, _ target: Target) {
        self.image = image
        self.title = title
        self.target = target
    }
}

// MARK: -

open class BaseViewController: UIViewController {
    // MARK: - Variables
    
    var isRequestingAPI = true
    var scrollDelegateFunc: ((UIScrollView) -> Void)?
    
    // MARK: - UI Elements
    
    private lazy var hub: JGProgressHUD = {
        let hub = JGProgressHUD(style: .dark)
        return hub
    }()
    
    lazy var searchBar: PaddingTextField = {
        let searchBar = PaddingTextField()
        searchBar.setDefaultBackgroundColor()
        searchBar.layer.cornerRadius = 5
        searchBar.layer.masksToBounds = true
        searchBar.placeholder = TextManager.search.localized()
        searchBar.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        searchBar.returnKeyType = .search
        searchBar.fontSizePlaceholder(text: TextManager.search.localized(), size: FontSize.h2.rawValue)
        var rect = navigationController?.navigationBar.frame ?? CGRect.zero
        rect.size.height = 36
        searchBar.frame = rect
        searchBar.clearButtonMode = .whileEditing
        searchBar.addTarget(self, action: #selector(touchInSearchBar), for: .editingDidBegin)
        searchBar.addTarget(self, action: #selector(searchBarValueChange(_:)), for: .editingChanged)
        searchBar.delegate = self
        return searchBar
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchInScrollView))
        tapGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapGesture)
        return scrollView
    }()
    
    lazy var emptyView: EmptyView = {
        let view = EmptyView()
        view.isHidden = true
        return view
    }()
    
    private (set) lazy var tapGestureOnSuperView = UITapGestureRecognizer(target: self,
                                                                          action: #selector(touchInScrollView))
    
    // MARK: - View LifeCycles
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.setupUIComponents()
        self.addTapOnSuperViewDismissKeyboard()
    }
    
    // MARK: - Override Methods
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - UI Actions
    
    @objc func touchUpInBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func touchUpInLeftBarButtonItem() {}
    
    @objc func touchUpInRightBarButtonItem() {}
    
    @objc func searchBarValueChange(_ textField: UITextField) {}
    
    @objc func touchInSearchBar() {}
    
    @objc func keyboardWillShow(_ notification: NSNotification) {}
    
    @objc func keyboardWillHide(_ notification: NSNotification) {}
    
    @objc func touchInScrollView() {
        view.endEditing(true)
    }
    
    @objc func touchInCartButton() {
        
    }
    
    @objc func touchInNotificationButton() {
    }
    
    // MARK: - Public methods
    
    func showLoading() {
        view.endEditing(true)
        hub.show(in: view)
    }
    
    func hideLoading() {
        hub.dismiss()
    }
    
    // MARK: - Helper Method

    func setupUIComponents() {
        self.view.setDefaultBackgroundColor()
        self.addBackButtonIfNeeded()
    }
    
    func addTapOnSuperViewDismissKeyboard() {
        tapGestureOnSuperView.cancelsTouchesInView = false
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGestureOnSuperView)
    }

    func addBackButtonIfNeeded() {
        let numberOfVC = navigationController?.viewControllers.count ?? 0
        guard numberOfVC > 1 else { return }
        let target: Target = (target: self, #selector(touchUpInBackButton))
        let barbuttonItemModel = BarButtonItemModel(ImageManager.back, target)
        navigationItem.leftBarButtonItem = buildBarButton(from: barbuttonItemModel)
    }
    
    func buildBarButton(from itemModel: BarButtonItemModel) -> UIBarButtonItem {
        let target = itemModel.target
        let customButton = UIButton(type: .custom)
        customButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        if itemModel.image != nil {
            let image = itemModel.image?.withRenderingMode(.alwaysOriginal)
            customButton.setImage(image, for: .normal)
            customButton.tintColor = UIColor.white
        } else if itemModel.title != nil {
            customButton.setTitle(itemModel.title!, for: .normal)
            customButton.setTitleColor(UIColor.white, for: .normal)
        }
        
        customButton.addTarget(target.target, action: target.selector, for: .touchUpInside)
        return UIBarButtonItem(customView: customButton)
    }
    
    func addBarItems(with itemModels: [BarButtonItemModel], type: BarButtonItemType = .right) {
        var barButtonItems: [UIBarButtonItem] = []
        itemModels.forEach {
            barButtonItems.append(buildBarButton(from: $0))
        }
        if type == .right {
            navigationItem.rightBarButtonItems = barButtonItems
        } else {
            navigationItem.leftBarButtonItems = barButtonItems
        }
    }
    
    func setRightNavigationBar(_ image: UIImage? = nil) {
        if image != nil {
            let rightBarItemTarget: Target = (target: self, selector: #selector(touchUpInRightBarButtonItem))
            let rightBarButtonModel = BarButtonItemModel(image, rightBarItemTarget)
            addBarItems(with: [rightBarButtonModel], type: .right)
        }
    }
    
    func setLeftNavigationBar(_ image: UIImage? = nil) {
        if image != nil {
            let leftBarItemTarget: Target = (target: self, selector: #selector(touchUpInLeftBarButtonItem))
            let leftBarButtonModel = BarButtonItemModel(image, leftBarItemTarget)
            addBarItems(with: [leftBarButtonModel], type: .left)
        }
    }
    
    // MARK: - Layout
    func layoutScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
            }
            make.left.right.bottom.equalToSuperview()
        }
    }
    
}

// MARK: - UITextFieldDelegate

extension BaseViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.addBottomBorder(UIColor.background)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textField.addBottomBorder(UIColor.separator)
    }
}

extension BaseViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
