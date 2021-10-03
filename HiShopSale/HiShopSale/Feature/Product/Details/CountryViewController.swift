//
//  CountryViewController.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 15/09/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol CountryViewControllerDelegate: AnyObject {
    func handleSelectContry(name: String)
}

class CountryViewController: BaseViewController {
    
    weak var delegate: CountryViewControllerDelegate?
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.lightBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView.registerReusableCell(CountryCollectionViewCell.self)
        return collectionView
    }()
    
    var contries: [Country] = []
    var cacheContries: [Country] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Quốc gia"
        layoutCollectionView()
        requestAPIContry()
        navigationItem.titleView = searchBar

    }
    
    override func searchBarValueChange(_ textField: UITextField) {
        guard var searchText = textField.text, searchText != "" else {
            contries = cacheContries
            collectionView.reloadData()
            return
        }
        searchText = searchText.normalizeSearchText
        contries = cacheContries.filter { $0.name.normalizeSearchText.contains(searchText) }
        collectionView.reloadData()
    }
    
    private func layoutCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.centerX
                .centerY
                .equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width
                .equalToSuperview()
                .offset(-dimension.normalMargin)
        }
    }
    
    func requestAPIContry() {
        guard let path = Bundle.main.path(forResource: "Detail", ofType: "json") else {
            fatalError("Not available json")
        }
        
        let url = URL(fileURLWithPath: path)
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case.success(let value):
                let json = JSON(value)
                self.contries = json.arrayValue.map {Country(json: $0)}
                self.cacheContries = self.contries
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
        
    }
}

extension CountryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.contries.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CountryCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configCell(country: contries[indexPath.row])
        return cell
    }
}

extension CountryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
}

extension CountryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let name = contries[indexPath.row].name
        self.navigationController?.popViewControllerWithHandler {
            self.delegate?.handleSelectContry(name: name)
        }
    }
}
