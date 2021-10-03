//
//  FilterCouponPulleyView.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 09/08/2021.
//

import UIKit
import RxSwift

protocol FilterStatisticalViewDelegate: AnyObject{
    func handleFilterSelected(type: String, time: String, filterType: FilterCouponOrderType, typeValidation: FilterCupponByValidation)
}
class FilterStatisticalView: ShowHidePulleyView {

    var disposeBag = DisposeBag()
    var formString = ""
    var timeString = ""
    var month = ""
    var year  = ""
    weak var delegate: FilterStatisticalViewDelegate?
    
    private var selectedDate = Date()
    
    // MARK: - Define Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.whatDoYouWantToView.localized()
        label.textAlignment = .center
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .bold)
        return label
    }()
    
    fileprivate lazy var checkListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.headerReferenceSize = CGSize(width: self.frame.width, height: 20)
        layout.footerReferenceSize = CGSize(width: self.frame.width, height: 24)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerReusableCell(CheckListCollectionViewCell.self)
        collectionView.registerReusableSupplementaryView(TitleCollectionViewHeaderCell.self,
                                                         forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        collectionView.registerReusableSupplementaryView(BaseCollectionViewHeaderFooterCell.self,
                                                         forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
        return collectionView
    }()
    
    
    private (set) lazy var monthTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.padding =  UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1
        textField.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        textField.textColor = UIColor.bodyText
        textField.layer.borderColor = UIColor.lightSeparator.cgColor
        textField.layer.cornerRadius = dimension.cornerRadiusSmall
        textField.rightImage = ImageManager.dropDown
        textField.placeholder = selectedDate.serverMonthFormat
        textField.inputView = monthPickerView
        textField.addTarget(self, action: #selector(textFieldValueChangeMonth), for: .editingDidEnd)
        return textField
    }()
    
    private (set) lazy var yearTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.padding =  UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1
        textField.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        textField.textColor = UIColor.bodyText
        textField.layer.borderColor = UIColor.lightSeparator.cgColor
        textField.layer.cornerRadius = dimension.cornerRadiusSmall
        textField.rightImage = ImageManager.dropDown
        textField.placeholder = selectedDate.serverYearFormat
        textField.inputView = yearPickerView
        textField.addTarget(self, action: #selector(textFieldValueChangeYeah), for: .editingDidEnd)
        return textField
    }()
    
    let monthPickerView: MonthYearPickerView = {
        let picker = MonthYearPickerView()
        return picker
    }()
    
    let yearPickerView: YearPickerView = {
        let picker = YearPickerView()
        return picker
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.cancel.localized(), for: .normal)
        button.setTitleColor(UIColor.bodyText, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                                    weight: .bold)
        button.backgroundColor = UIColor.lightSeparator
        button.layer.borderColor = UIColor.separator.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 5
        button.rx.controlEvent(.touchUpInside).asObservable().subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.hidePulley()
        }).disposed(by: self.disposeBag)
        return button
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.confirm.localized(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                                     weight: .bold)
        button.backgroundColor = UIColor.second
        button.layer.cornerRadius = 5
        button.rx.controlEvent(.touchUpInside).asObservable().subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.delegate?.handleFilterSelected(type: self.formString,
                                                time: self.viewModel.timeFilter,
                                                filterType: self.viewModel.selectedOrderTypes[0],
                                                typeValidation: self.viewModel.selectedValidations[0])
            self.hidePulley()
        }).disposed(by: self.disposeBag)
        return button
    }()
    
    fileprivate let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    private let viewModel = FilterCouponViewModel()
    
    var handleConfirmFilter: ((String,String, FilterCouponOrderType) -> Void)?
    
    override func initialize() {
        super.initialize()
        self.layoutTitleLabel()
        self.layoutCheckListCollectionView()
        self.layoutMonthTextField()
        self.layoutYearTextField()
        self.layoutLineView()
        self.layoutCancelButton()
        self.layoutConfirmButton()
    }
    
    override func estimatePulleyMinHeight() -> CGFloat {
        return 350 + UIApplication.shared.bottomSafeAreaInsets
    }
    
    @objc func textFieldValueChangeMonth() {
        var month = ""
        if monthPickerView.month < 10 {
            month = "0\(monthPickerView.month.description)-\(monthPickerView.year.description)"
        } else {
            month = monthPickerView.month.description + "-" + monthPickerView.year.description
        }
        
        self.monthTextField.text = month
        self.viewModel.setTimeFilter(time: month)
    }
    
    @objc func textFieldValueChangeYeah() {
        let year  =  yearPickerView.year.description
        self.yearTextField.text  = year
        self.viewModel.setTimeFilter(time: year)
    }
    
    
    private func layoutTitleLabel() {
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    
    private func layoutCheckListCollectionView() {
        self.contentView.addSubview(self.checkListCollectionView)
        self.checkListCollectionView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.left.equalToSuperview().offset(dimension.normalMargin)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(dimension.normalMargin)
            make.height.equalTo(180)
        }
    }
    
    private func layoutMonthTextField() {
        self.contentView.addSubview(self.monthTextField)
        self.monthTextField.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.width.equalTo((ScreenSize.SCREEN_WIDTH - dimension.largeMargin_32 - dimension.normalMargin ) / 2)
            make.left.equalTo(self.checkListCollectionView)
            make.top.equalTo(self.checkListCollectionView.snp.bottom)
        }
    }
    
    private func layoutYearTextField() {
        self.contentView.addSubview(self.yearTextField)
        self.yearTextField.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.width.equalTo((ScreenSize.SCREEN_WIDTH - dimension.largeMargin_32 - dimension.normalMargin ) / 2)
            make.right.equalToSuperview()
                .offset(-dimension.normalMargin)
            make.top.equalTo(self.checkListCollectionView.snp.bottom)
        }
    }
    
    private func layoutLineView() {
        self.contentView.addSubview(self.lineView)
        self.lineView.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.width.centerX.equalToSuperview()
            make.top.equalTo(self.monthTextField.snp.bottom)
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutCancelButton() {
        self.contentView.addSubview(self.cancelButton)
        self.cancelButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(dimension.mediumMargin)
            make.height.equalTo(48)
            make.trailing.equalTo(self.contentView.snp.centerX).offset(-dimension.mediumMargin)
            make.top.equalTo(self.lineView.snp.bottom).offset(16)
        }
    }
    
    private func layoutConfirmButton() {
        self.contentView.addSubview(self.confirmButton)
        self.confirmButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-dimension.mediumMargin)
            make.height.top.equalTo(self.cancelButton)
            make.leading.equalTo(self.contentView.snp.centerX).offset(dimension.mediumMargin)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension FilterStatisticalView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CheckListCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let isSelected = self.viewModel.isSelectedCell(at: indexPath)
        if indexPath.section == 0 {
            if let orderType = FilterCouponOrderType(rawValue: indexPath.row) {
                cell.configureData(with: orderType.description, isSelected)
            }
        } else {
            if let validationType = FilterCupponByValidation(rawValue: indexPath.row) {
                cell.configureData(with: validationType.description, isSelected)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header: TitleCollectionViewHeaderCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
            if indexPath.section == 0 {
                header.configureTitle(TextManager.form.localized())
            } else {
                header.configureTitle(TextManager.time.localized())
            }
            return header
        } else {
            let footer: BaseCollectionViewHeaderFooterCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
            return footer
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FilterStatisticalView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.width / 2, height: 50)
        } else{
            return CGSize(width: collectionView.frame.width / 2, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: collectionView.frame.width, height: 24)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension FilterStatisticalView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let orderType = FilterCouponOrderType(rawValue: indexPath.row),
                self.viewModel.didSelectOrderType(orderType){
                self.checkListCollectionView.reloadData()
                self.formString = self.viewModel.selectedOrderTypes[0].key
            }
        } else {
            if let validationType = FilterCupponByValidation(rawValue: indexPath.row),
                self.viewModel.didSelectValidationType(validationType) {
                self.checkListCollectionView.reloadData()
                self.timeString = self.viewModel.selectedValidations[0].description
            }
        }
    }
}
