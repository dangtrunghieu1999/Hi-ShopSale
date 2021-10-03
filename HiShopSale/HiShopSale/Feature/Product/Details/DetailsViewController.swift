//
//  DetailsViewController.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 03/07/2021.
//

import UIKit
protocol DetailsViewControllerDelegate: AnyObject {
    func completeCreateProduct()
}

class DetailsViewController: BaseViewController {
    
    weak var delegate: DetailsViewControllerDelegate?
    
    let centerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis         = .vertical
        stackView.alignment    = .fill
        stackView.distribution = .fill
        stackView.spacing = dimension.normalMargin
        return stackView
    }()
    
    let firstView  = UIView()
    let secondView = UIView()
    let thirdView  = UIView()
    let fouthView  = UIView()
    
    fileprivate lazy var productUseTextView: BaseTextView = {
        let textview = BaseTextView()
        textview.titleText = TextManager.tutorial
        textview.placeholder = TextManager.tutorial
        textview.boderColor = UIColor.second
        textview.addressTextView.delegate = self
        return textview
    }()

    fileprivate lazy var guaranteeTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.textField.fontPlaceholder(text: TextManager.guarantee_Month.localized(),
                                                size: FontSize.h1.rawValue)
        textField.titleText = TextManager.guarantee_Month.localized()
        textField.keyboardType = .numberPad
        textField.boderColor = UIColor.second
        textField.addTarget(self, action:#selector(textFieldValueChange(_:)),
                            for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var productByTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.textField.fontPlaceholder(text: TextManager.productBy.localized(),
                                                size: FontSize.h1.rawValue)
        textField.titleText = TextManager.productBy.localized()
        textField.boderColor = UIColor.second
        textField.addTarget(self, action:#selector(textFieldValueChange(_:)),
                            for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var tradeMarkTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.textField.fontPlaceholder(text: TextManager.tradeMark.localized(),
                                                size: FontSize.h1.rawValue)
        textField.titleText = TextManager.tradeMark.localized()
        textField.boderColor = UIColor.second
        textField.addTarget(self, action:#selector(textFieldValueChange(_:)),
                            for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var materialProductTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.textField.fontPlaceholder(text: TextManager.material.localized(),
                                                size: FontSize.h1.rawValue)
        textField.titleText = TextManager.material.localized()
        textField.boderColor = UIColor.second
        textField.addTarget(self, action:#selector(textFieldValueChange(_:)),
                            for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var modelProductTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.textField.fontPlaceholder(text: TextManager.model.localized(),
                                                size: FontSize.h1.rawValue)
        textField.titleText = TextManager.model.localized()
        textField.boderColor = UIColor.second
        textField.addTarget(self, action:#selector(textFieldValueChange(_:)),
                            for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var madeByProductTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.textField.fontPlaceholder(text: TextManager.madeBy.localized(),
                                                size: FontSize.h1.rawValue)
        textField.titleText = TextManager.madeBy.localized()
        textField.rightTextfieldImage = ImageManager.dropDown
        textField.boderColor = UIColor.second
        textField.addTarget(self, action:#selector(textFieldValueChange(_:)),
                            for: .editingChanged)
        textField.addTarget(self, action:#selector(textFieldBeginEditing(_:)),
                            for: .editingDidBegin)
        return textField
    }()
    
    fileprivate lazy var originProductTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.textField.fontPlaceholder(text: TextManager.origin.localized(),
                                                size: FontSize.h1.rawValue)
        textField.titleText = TextManager.origin.localized()
        textField.rightTextfieldImage = ImageManager.dropDown
        textField.boderColor = UIColor.second
        textField.addTarget(self, action:#selector(textFieldValueChange(_:)),
                            for: .editingChanged)
        textField.addTarget(self, action:#selector(textFieldBeginEditing(_:)),
                            for: .editingDidBegin)
        return textField
    }()
    
    fileprivate lazy var vatProductTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.textField.fontPlaceholder(text: TextManager.vat.localized(),
                                                size: FontSize.h1.rawValue)
        textField.titleText = TextManager.vat.localized()
        textField.boderColor = UIColor.second
        textField.addTarget(self, action:#selector(textFieldValueChange(_:)),
                            for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.save.localized(), for: .normal)
        button.backgroundColor = UIColor.disable
        button.setTitleColor(UIColor.bodyText, for: .normal)
        button.layer.cornerRadius = dimension.cornerRadiusSmall
        button.layer.masksToBounds = true
        button.isUserInteractionEnabled = false
        button.addTarget(self, action: #selector(tapSaveButton), for: .touchUpInside)
        return button
    }()
    
    private (set) var product = Product()
    private var detailString = ""
    var original = ""
    
    convenience init(_ product: Product) {
        self.init()
        self.product = product
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Thông số chi tiết"
        layoutScrollView()
        layoutCenterStackView()
        layoutFirstView()
        layoutSecondView()
        layoutProductUseTextView()
        layoutThirdView()
        layoutFouthView()
        layoutSaveButton()
    }
    private func checkCanEnableNextButton() {
        guard let productUse = productUseTextView.addressTextView.text,
              let guarantee  = guaranteeTextField.text,
              let provide    = productByTextField.text,
              let tradeMark  = tradeMarkTextField.text,
              let origin     = originProductTextField.text,
              let material   = materialProductTextField.text,
              let model      = modelProductTextField.text,
              let madeBy     = madeByProductTextField.text,
              let vat        = vatProductTextField.text
        else {
            return
        }
        
        if productUse != "" && guarantee != ""
        && provide != "" && tradeMark != ""
        && origin  != "" && material != ""
            && model != "" && madeBy != ""
            && vat != "" {
            
            self.detailString = provide + ";" + tradeMark + ";"
                + origin + ";" + madeBy + ";" + productUse + ";"
                + material + ";" + model + ";" + vat + ";" + guarantee
            
            self.saveButton.isUserInteractionEnabled = true
            self.saveButton.setTitleColor(UIColor.white, for: .normal)
            self.saveButton.backgroundColor = UIColor.thirdColor
        } else {
            self.saveButton.isUserInteractionEnabled = false
            self.saveButton.setTitleColor(UIColor.bodyText, for: .normal)
            self.saveButton.backgroundColor = UIColor.disable
        }
    }
    
    @objc private func textFieldBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        let vc = CountryViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func clearTextFieldComplete() {
        self.productUseTextView.addressTextView.text = ""
        self.guaranteeTextField.text = ""
        self.productByTextField.text = ""
        self.tradeMarkTextField.text = ""
        self.originProductTextField.text = ""
        self.materialProductTextField.text = ""
        self.modelProductTextField.text = ""
        self.madeByProductTextField.text = ""
        self.vatProductTextField.text = ""
    }
    
    @objc private func textFieldValueChange(_ textField: UITextField) {
        checkCanEnableNextButton()
    }
     
    @objc private func tapSaveButton() {
        product.detail += self.detailString
        
        let endPoint = ProductEndPoint.createProduct(params: product.toDictionary())
        self.showLoading()
        
        APIService.request(endPoint: endPoint) { [weak self] apiResponse in
            guard let self = self else { return }
            self.hideLoading()
            self.clearTextFieldComplete()
            self.navigationController?.popViewControllerWithHandler(completion: {
                self.delegate?.completeCreateProduct()
            })
        } onFailure: { error in
            self.hideLoading()
        } onRequestFail: {
            self.hideLoading()
        }

    }
    
    private func layoutCenterStackView() {
        scrollView.addSubview(centerStackView)
        centerStackView.snp.makeConstraints { (make) in
            make.left.equalTo(view)
                .offset(dimension.normalMargin)
            make.right.equalTo(view)
                .offset(-dimension.normalMargin)
            make.bottom.equalToSuperview()
                .offset(-dimension.largeMargin)
            make.top.equalToSuperview()
                .offset(dimension.largeMargin)
        }
    }
    
    private func layoutFirstView() {
        centerStackView.addArrangedSubview(firstView)
        firstView.addSubview(productByTextField)
        productByTextField.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.trailing.equalTo(firstView.snp.centerX)
                .offset(-dimension.mediumMargin)
        }
        
        firstView.addSubview(tradeMarkTextField)
        tradeMarkTextField.snp.makeConstraints { (make) in
            make.trailing.top.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.leading.equalTo(firstView.snp.centerX)
                .offset(dimension.mediumMargin)
        }
    }
    
    private func layoutSecondView() {
        centerStackView.addArrangedSubview(secondView)
        secondView.addSubview(originProductTextField)
        originProductTextField.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.trailing.equalTo(secondView.snp.centerX)
                .offset(-dimension.mediumMargin)
        }
        
        secondView.addSubview(madeByProductTextField)
        madeByProductTextField.snp.makeConstraints { (make) in
            make.trailing.top.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.leading.equalTo(secondView.snp.centerX)
                .offset(dimension.mediumMargin)
        }
    }
    
    private func layoutProductUseTextView() {
        centerStackView.addArrangedSubview(productUseTextView)
    }
    
    private func layoutThirdView() {
        centerStackView.addArrangedSubview(thirdView)
        thirdView.addSubview(materialProductTextField)
        materialProductTextField.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.trailing.equalTo(thirdView.snp.centerX)
                .offset(-dimension.mediumMargin)
        }
        
        thirdView.addSubview(modelProductTextField)
        modelProductTextField.snp.makeConstraints { (make) in
            make.trailing.top.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.leading.equalTo(thirdView.snp.centerX)
                .offset(dimension.mediumMargin)
        }
    }
    
    private func layoutFouthView() {
        centerStackView.addArrangedSubview(fouthView)
        fouthView.addSubview(vatProductTextField)
        vatProductTextField.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.trailing.equalTo(fouthView.snp.centerX)
                .offset(-dimension.mediumMargin)
        }
        
        fouthView.addSubview(guaranteeTextField)
        guaranteeTextField.snp.makeConstraints { (make) in
            make.trailing.top.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.leading.equalTo(fouthView.snp.centerX)
                .offset(dimension.mediumMargin)
        }
    }

    private func layoutSaveButton() {
        centerStackView.addArrangedSubview(saveButton)
        saveButton.snp.makeConstraints { (make) in
            make.height.equalTo(dimension.largeHeightButton)
        }
    }
}

// MARK: - UITextViewDelegate

extension DetailsViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == TextManager.tutorial.localized() {
            textView.text = ""
        }
        
        textView.textColor = UIColor.titleText
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = TextManager.tutorial.localized()
            textView.textColor = UIColor.placeholder
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        checkCanEnableNextButton()
    }
}

extension DetailsViewController: CountryViewControllerDelegate {
    func handleSelectContry(name: String) {
        if self.original == "" {
            self.originProductTextField.text = name
            self.original = name
        } else {
            self.madeByProductTextField.text = name
            self.original = ""
        }
    }
}
