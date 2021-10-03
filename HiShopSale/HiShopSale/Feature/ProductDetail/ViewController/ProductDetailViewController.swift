//
//  ProductViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/12/21.
//

import UIKit
import IGListKit
import SwiftyJSON
import Alamofire

protocol ProductDetailViewControllerDelegate: AnyObject {
    func handleDeleteProduct(_ product: Product)
    func handleUpdateProduct(_ product: Product)
}

class ProductDetailViewController: BaseViewController {
    
    // MARK: - Variables
    fileprivate var isExpandDescriptionCell = false
    fileprivate(set) lazy var product = Product()
    private (set) var checkPopView: Bool = false
    
    fileprivate var productInfoCellHeight:  CGFloat?
    fileprivate var desciptionCellHeight:   CGFloat?
    fileprivate lazy var comments:         [Comment] = []
    weak var delegate: ProductDetailViewControllerDelegate?
    
    // MARK: - UI Elements
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 4
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.lightBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerReusableCell()
        layoutCollectionView()
        navigationItem.title = TextManager.productDetail.localized()
    }
    
    
    // MARK: - Helper Method
    
    func configData(_ product: Product, isCheck: Bool = false ) {
        self.product = product
        self.checkPopView = isCheck
        collectionView.reloadData()
        getProductById(id: product.id ?? 0)
    }
    
    func scrollCommentProduct() {
        let indexPath = IndexPath(row: 0, section: ProductDetailType.comment.rawValue)
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: false)
            }, completion: { [weak self] _ in
                self?.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .bottom)
                self?.collectionView(self?.collectionView ?? UICollectionView(), didSelectItemAt: indexPath)
                }
            )
        }
        self.collectionView.reloadData()
    }
    
    private func registerReusableCell() {
        collectionView.registerReusableCell(InfoCollectionViewCell.self)
        collectionView.registerReusableCell(AdvanedCollectionViewCell.self)
        collectionView.registerReusableCell(DetailsCollectionViewCell.self)
        collectionView.registerReusableCell(CommentCollectionViewCell.self)
        collectionView.registerReusableCell(ChildCommentCollectionViewCell.self)
        collectionView.registerReusableCell(ProductCollectionViewCell.self)
        collectionView.registerReusableCell(DescriptionsCollectionViewCell.self)
        collectionView.registerReusableCell(BaseCollectionViewCell.self)
        collectionView.registerReusableCell(EmptyCollectionViewCell.self)
        collectionView
            .registerReusableSupplementaryView(TitleCollectionViewHeaderCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
    }


    private func layoutCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            if #available(iOS 11, *) {
                make.bottom
                    .equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom
                    .equalTo(bottomLayoutGuide.snp.top)
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProductDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let sectionType = ProductDetailType(rawValue: indexPath.section)
        else { return .zero }
        
        switch sectionType {
        case .infomation:
            if let productInfoCellHeight = productInfoCellHeight {
                return CGSize(width: collectionView.frame.width,
                              height: productInfoCellHeight)
            } else {
                productInfoCellHeight = InfoCollectionViewCell.estimateHeight(product)
                return CGSize(width: collectionView.frame.width,
                              height: productInfoCellHeight ?? 0)
            }
        case .advanedShop:
            return CGSize(width: collectionView.frame.width, height: 140)
        case .infoDetail:
            return CGSize(width: collectionView.frame.width, height: 270)
        case .description:
            desciptionCellHeight = DescriptionsCollectionViewCell.estimateHeight(product)
            return CGSize(width: collectionView.frame.width,
                          height: desciptionCellHeight ?? 0)
        case .comment:
            if product.comments.isEmpty {
                return CGSize(width: collectionView.frame.width, height: 140)
            } else {
                guard let comment = product.commentInProductDetail[safe: indexPath.row]
                else { return .zero }
                return CGSize(width: collectionView.frame.width,
                              height: CommentCollectionViewCell.estimateHeight(comment))
            }
        default:
            return CGSize(width: collectionView.frame.width, height: 8)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let sectionType = ProductDetailType(rawValue: section) else {
            return .zero
        }
        return sectionType.sizeForHeader()
    }
}

// MARK: - UICollectionViewDataSource

extension ProductDetailViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return ProductDetailType.numberSection()
    }
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let sectionType = ProductDetailType(rawValue: section) else { return 0 }
        switch sectionType {
        case .comment:
            if (product.comments.isEmpty) {
                return 1
            } else {
                return product.numberCommentInProductDetail
            }
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionType = ProductDetailType(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        
        switch sectionType {
        case .infomation:
            let cell: InfoCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configDataInfomation(product: product)
            cell.delegate = self
            return cell
        case .advanedShop:
            let cell: AdvanedCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        case .infoDetail:
            let cell: DetailsCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configCell(detail: product.detail)
            cell.delegate = self
            return cell
        case .description:
            let cell: DescriptionsCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configData(product)
            return cell
        case .comment:
            if product.comments.isEmpty {
                let emptyCell: EmptyCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                emptyCell.imageSize = CGSize(width: 40, height: 40)
                emptyCell.messageFont = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
                emptyCell.image = ImageManager.comment
                emptyCell.message = TextManager.emptyComment.localized()
                return emptyCell
            } else {
                let comment = product.commentInProductDetail[indexPath.row]
                
                if comment.isParrentComment {
                    let cell: CommentCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                    cell.configData(comment: comment)
                    cell.delegate = self
                    return cell
                } else {
                    let cell: ChildCommentCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                    cell.configData(comment: comment)
                    cell.delegate = self
                    return cell
                }
            }
        default:
            let cell: BaseCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.backgroundColor = UIColor.separator
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionType = ProductDetailType(rawValue: indexPath.section) else {
            return UICollectionReusableView()
        }
        
        if kind == UICollectionView.elementKindSectionHeader {
            let header: TitleCollectionViewHeaderCell =
                collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
            header.title = sectionType.title
            header.textColor = UIColor.bodyText
            return header
        } else {
            return UICollectionReusableView()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension ProductDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sectionType = ProductDetailType(rawValue: indexPath.section) else { return }
        
        switch sectionType {
        case .comment:
            let commentVC = ProductCommentViewController()
            commentVC.delegate = self
            commentVC.isCheck = self.checkPopView
            commentVC.configData(comments: product.comments)
            commentVC.configData(productId: product.id)
            navigationController?.pushViewController(commentVC, animated: true)
        default:
            break
        }
    }
}

// MARK: - DetailsCollectionViewCellDelegate
extension ProductDetailViewController: DetailsCollectionViewCellDelegate {
    func didTapSeemoreParamter() {
        AppRouter.presentViewParameterProduct(viewController: self,
                                              detail: product.detail,
                                              id: product.id ?? 0)
    }
}

// MARK: - ProductCommentViewControllerDelegate
extension ProductDetailViewController: ProductCommentViewControllerDelegate {
    func updateNewComments(_ comments: [Comment]) {
        product.comments = comments
        collectionView.reloadData()
    }
}

// MARK: - ProductDetailCommentCollectionViewCellDelegate
extension ProductDetailViewController: DetailCommentCollectionViewCellDelegate {
    func didSelectLikeComment(_ comment: Comment) {
        
    }
    
    func didSelectReplyComment(_ comment: Comment) {
        let commentVC = ProductCommentViewController()
        commentVC.delegate = self
        commentVC.configData(comments: product.comments)
        commentVC.configData(productId: product.id, replyComment: comment)
        navigationController?.pushViewController(commentVC, animated: true)
    }
}


// MARK: - API

extension ProductDetailViewController {
    
    private func reloadDataWhenFinishLoadAPI() {
        self.isRequestingAPI = false
        self.collectionView.reloadData()
    }
    
    func getProductById(id: Int) {
        let endPoint = ProductEndPoint.getProductById(parameters: ["id": id])
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            guard let self = self else { return }
            if let product = apiResponse.toObject(Product.self) {
                self.product = product
            }
            self.collectionView.reloadData()
        }, onFailure: { (apiError) in
            AlertManager.shared.show(message:
                                        TextManager.errorMessage.localized())
        }) {
            AlertManager.shared.show(message:
                                        TextManager.errorMessage.localized())
        }
    }
}

// MARK: - InfoCollectionViewCellDelegate
extension ProductDetailViewController: InfoCollectionViewCellDelegate {
    func handleSettingProduct() {
        let vc = UpdateProductViewController(product: product)
        vc.delgate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func handleDeleteProduct() {
        AlertManager.shared.showConfirm(TextManager.deleteProduct.localized())
        { (action) in
            
            // delete product api
            self.navigationController?.popViewControllerWithHandler(completion: {
                self.delegate?.handleDeleteProduct(self.product)
            })
        }
    }
}

// MARK: - UpdateProductViewControllerDelegate
extension ProductDetailViewController: UpdateProductViewControllerDelegate {
    func handleSuccessUpdate(product: Product) {
        self.configData(product)
        self.delegate?.handleUpdateProduct(product)
    }
}
