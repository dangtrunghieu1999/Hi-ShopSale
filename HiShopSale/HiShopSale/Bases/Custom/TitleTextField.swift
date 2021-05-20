//
//  TitleTextField.swift
//  ZoZoApp
//
//  Created by MACOS on 6/9/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class TitleTextField: BaseView {

    // MARK: - Variables
    
    var keyboardType: UIKeyboardType = .default {
        didSet {
            textField.keyboardType = keyboardType
        }
    }
    
    var placeholder: String? {
        didSet {
            textField.placeholder = placeholder
        }
    }
    
    var textFieldBGColor: UIColor = UIColor.white {
        didSet {
            textField.backgroundColor = textFieldBGColor
        }
    }
    
    var text: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
        }
    }
    
    var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    var titleLabelAttributed: NSAttributedString? {
        didSet {
            titleLabel.attributedText = titleLabelAttributed
        }
    }
    
    var textFieldInputView: UIView? {
        didSet {
            textField.inputView = textFieldInputView
        }
    }
    
    var rightTextfieldImage: UIImage? {
        didSet {
            textField.rightImage = rightTextfieldImage
        }
    }
    
    var colorLine: UIColor? {
        didSet {
            lineView.backgroundColor = colorLine
        }
    }
    
    // MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.titleText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        return label
    }()
    
    private (set) lazy var textField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.padding =  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textField.layer.masksToBounds = true
        return textField
    }()
    
    lazy var lineView: BaseView = {
        let view = BaseView()
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    // MARK: - LifeCycles
    
    override func initialize() {
        layoutTitleLabel()
        layoutTextField()
        layoutLineView()
    }
    
    func addTarget(_ target: Any?, action: Selector, for event: UIControl.Event) {
        textField.addTarget(target, action: action, for: event)
    }
    
    // MARK: - Layouts
    
    private func layoutTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
        }
    }
    
    private func layoutTextField() {
        addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(Dimension.shared.mediumMargin)
            make.height.equalTo(Dimension.shared.defaultHeightTextField)
            make.bottom.equalToSuperview()
        }
    }
    
    private func layoutLineView() {
        addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(textField)
            make.bottom.equalToSuperview()
                .offset(-1)
            make.height.equalTo(1)
        }
    }
    
}