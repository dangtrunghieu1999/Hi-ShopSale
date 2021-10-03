//
//  ProductViewController.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 26/05/2021.
//

import UIKit
import IQKeyboardManagerSwift

class ProductViewController: BaseViewController {
    
    fileprivate enum SectionType: Int {
        case header     = 0
        case products   = 1
    }
    
    fileprivate var productsResponse: [Product] = []
    fileprivate var products: [Product]         = []
    fileprivate var cachedProducts: [Product]   = []
    fileprivate var currentPage                 = 0
    fileprivate var isLoadMore                  = false
    fileprivate var canLoadMore                 = true
    
    fileprivate lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.background
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    fileprivate lazy var listProductCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 6
        layout.minimumInteritemSpacing = 6
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.lightBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView.refreshControl = refreshControl
        collectionView.registerReusableCell(EmptyCollectionViewCell.self)
        collectionView.registerReusableCell(ProductCollectionViewCell.self)
        
        collectionView.registerReusableSupplementaryView(
            ShopHomeProductListSearchHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        
        collectionView.registerReusableSupplementaryView(
            LoadMoreCollectionViewCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
        
        return collectionView
    }()
    
    // MARK: - LifeCycles
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightBackground
        self.navigationItem.title = TextManager.product
        layoutListProductCollectionView()
        requestAPIProducts()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
    }
    
    // MARK: - UI Actions
    
    @objc private func pullToRefresh() {
        self.currentPage = 0
        canLoadMore = true
        requestAPIProducts()
    }
    
    private func reloadDataWhenFinishLoadAPI() {
        self.isRequestingAPI = false
        self.isLoadMore = false
        self.canLoadMore = true
        self.listProductCollectionView.reloadData()
    }

    // MARK: - API Helper
    
    func requestAPIProducts() {
        let params: [String: Any] = ["pageNumber": currentPage,
                                     "pageSize": AppConfig.defaultProductPerPage]
        let endPoint = ShopEndPoint.getAllProductById(params: params)
        
        if !isLoadMore {
            isRequestingAPI = true
        }
        
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            guard let self = self else { return }
            let json       = apiResponse.data?["content"]
            self.productsResponse  = json?.arrayValue.map { Product(json: $0)} ?? []
            
            if self.isLoadMore {
                self.cachedProducts.append(contentsOf: self.productsResponse)
            } else {
                self.cachedProducts = self.productsResponse
            }
            
            if self.canLoadMore {
                self.canLoadMore = !self.productsResponse.isEmpty
            }
            
            self.isRequestingAPI = false
            
            if self.isLoadMore {
                self.isLoadMore = false
                var reloadIndexPaths: [IndexPath] = []
                let numberProducts = self.products.count
                
                for index in 0..<self.productsResponse.count {
                    reloadIndexPaths.append(
                        IndexPath(item: numberProducts + index,
                                  section:  SectionType.products.rawValue))
                }
                
                self.products = self.cachedProducts
                self.listProductCollectionView.insertItems(at: reloadIndexPaths)
            } else {
                self.products = self.cachedProducts
                self.listProductCollectionView.reloadData()
            }
            
            if self.products.count < 3 {
                self.listProductCollectionView.contentInset =
                    UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
            }
            self.refreshControl.endRefreshing()
        }, onFailure: { [weak self] (apiError) in
            guard let self = self else { return }
            self.reloadDataWhenFinishLoadAPI()
            AlertManager.shared.showToast()
            
        }) { [weak self] in
            guard let self = self else { return }
            self.reloadDataWhenFinishLoadAPI()
            AlertManager.shared.showToast()
        }
    }
    
    func deleteProductById(id: Int) {
        
        let endPoint = ShopEndPoint.deleteProductById(params: ["id": id])
        
        APIService.request(endPoint: endPoint) { apiResponse in
            
        } onFailure: { error in
            
        } onRequestFail: {
            
        }
    }
    
    
    // MARK: - Layouts
    
    private func layoutListProductCollectionView() {
        view.addSubview(listProductCollectionView)
        listProductCollectionView.snp.makeConstraints { (make) in
            make.centerX
                .centerY
                .equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width
                .equalToSuperview()
                .offset(-dimension.normalMargin)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ProductViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if section == SectionType.header.rawValue {
            return 0
        } else {
            if isRequestingAPI {
                return 6
            } else if products.isEmpty {
                return 1
            } else {
                return products.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == SectionType.header.rawValue {
            return UICollectionViewCell()
        }
        
        if products.isEmpty && !isRequestingAPI {
            let cell: EmptyCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.message = TextManager.emptyProducts.localized()
            cell.image   = ImageManager.icon_logo2
            self.listProductCollectionView.backgroundColor = .white
            return cell
        } else {
            let cell: ProductCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            if let product = products[safe: indexPath.row] {
                cell.configCell(product)
            }
            if !isRequestingAPI {
                cell.stopShimmering()
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader
            && indexPath.section == SectionType.header.rawValue {
            let header: ShopHomeProductListSearchHeaderView =
                collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                for: indexPath)
            header.delegate = self
            return header
            
        } else if kind == UICollectionView.elementKindSectionFooter
                    && indexPath.section == SectionType.products.rawValue {
            let footer: LoadMoreCollectionViewCell =
                collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                for: indexPath)
            footer.animiate(isLoadMore)
            return footer
        } else {
            return UICollectionReusableView()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProductViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == SectionType.products.rawValue
            && products.isEmpty && !isRequestingAPI {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.width)
        } else if indexPath.section == SectionType.products.rawValue {
            return CGSize(width: (ScreenSize.SCREEN_WIDTH - 22 ) / 2, height: 320)
        } else {
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if isLoadMore && section == SectionType.products.rawValue {
            return CGSize(width: collectionView.frame.width, height: 70)
        } else {
            return CGSize(width: collectionView.frame.width, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == SectionType.header.rawValue {
            return CGSize(width: view.frame.width, height: 70)
        } else {
            return .zero
        }
    }
}

// MARK: - UICollectionViewDelegate

extension ProductViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let scrollDelegate = scrollDelegateFunc {
            scrollDelegate(scrollView)
        }
        
        let collectionViewOffset = listProductCollectionView.contentSize.height -
            listProductCollectionView.frame.size.height - 50
        if scrollView.contentOffset.y >= collectionViewOffset
            && !isLoadMore
            && !isRequestingAPI
            && canLoadMore {
            
            currentPage += 1
            isLoadMore = true
            listProductCollectionView.reloadData()
            requestAPIProducts()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let vc = ProductDetailViewController()
        vc.delegate = self
        vc.configData(products[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProductViewController: ShopSearchViewDelegate {
    func didEndSearch() {
        canLoadMore = true
    }
    
    func didSearch(text: String?) {
        guard var searchText = text, searchText != "" else {
            canLoadMore = true
            products = cachedProducts
            listProductCollectionView.reloadSections(IndexSet(integer: SectionType.products.rawValue))
            return
        }
        
        canLoadMore = false
        searchText = searchText.normalizeSearchText
        products = cachedProducts.filter { $0.name.normalizeSearchText.contains(searchText) }
        listProductCollectionView.reloadSections(IndexSet(integer: SectionType.products.rawValue))
    }
}

extension ProductViewController: ProductDetailViewControllerDelegate {
    func handleDeleteProduct(_ product: Product) {
        if let index = products.firstIndex(where: { $0.id == product.id }),
            let cacheProductIndex = cachedProducts.firstIndex(where: { $0.id == product.id }) {
            AlertManager.shared.showToast(message: TextManager.deleteProductSuccess.localized())
            self.deleteProductById(id: product.id ?? 0)
            self.products.remove(at: index)
            self.cachedProducts.remove(at: cacheProductIndex)
            self.listProductCollectionView.deleteItems(at: [IndexPath(row: index,
                                                                      section: SectionType.products.rawValue)])
        } else {
            self.currentPage = 0
            requestAPIProducts()
        }
    }
    
    func handleUpdateProduct(_ product: Product) {
        self.currentPage = 0
        requestAPIProducts()
    }
}
