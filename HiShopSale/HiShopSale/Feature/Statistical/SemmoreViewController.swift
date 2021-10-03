//
//  SemmoreViewController.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 15/09/2021.
//

import UIKit

class SemmoreViewController: BaseViewController {

    var selectedOrderTypes: FilterCouponOrderType = .money
    var selectedValidations: FilterCupponByValidation = .month
    var timeString = Date().serverMonthFormat
    var charts: [Chart] = []
    var generalTite: String = ""
    var typeString = ""
    let widthScreen = ( ScreenSize.SCREEN_WIDTH - dimension.normalMargin * 3 ) / 2
    
    fileprivate lazy var generalTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.thirdColor
        label.textAlignment = .left
        label.text = generalTite
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        return label
    }()
    
    fileprivate lazy var timeTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.textAlignment = .left
        label.text = "Thời gian: " + timeString
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        return label
    }()
    
    fileprivate lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("In", for: .normal)
        button.backgroundColor = UIColor.thirdColor
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = dimension.cornerRadiusSmall
        button.layer.masksToBounds = true
        button.addRightIconLarge(image: ImageManager.icon_print ?? UIImage())
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Gửi file về email", for: .normal)
        button.backgroundColor = UIColor.primary
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = dimension.cornerRadiusSmall
        button.layer.masksToBounds = true
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(sendFileButton), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var keyTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.text = selectedValidations.value
        return label
    }()
    
    fileprivate lazy var valueTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.text = selectedOrderTypes.detail
        return label
    }()
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
        tableView.isScrollEnabled = true
        tableView.showsVerticalScrollIndicator = false
        tableView.registerReusableCell(SeeMoreTableViewCell.self)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutNextButton()
        layoutSendButton()
        layoutGeneralTitleLabel()
        layoutFormTitleLabel()
        layoutKeyTitleLabel()
        layoutValueTitleLabel()
        layoutTableView()
        tableView.reloadData()
    }
    
    @objc func imageWasSaved(_ image: UIImage, error: Error?, context: UnsafeMutableRawPointer) {
        if let error = error {
            print(error.localizedDescription)
            return
        }

        print("Image was saved in the photo gallery")
        UIApplication.shared.open(URL(string:"photos-redirect://")!)
    }
      
    func takeScreenshot(of view: UIView) {
        self.nextButton.isHidden = true
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: view.bounds.width, height: view.bounds.height),
            false,
            2
        )

        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        UIImageWriteToSavedPhotosAlbum(screenshot, self, #selector(imageWasSaved), nil)
    }
      
    @objc func actionButtonTapped() {
        UIView.animate(withDuration: 0.2, animations: {
            self.nextButton.backgroundColor = .thirdColor
        }) { _ in
            self.nextButton.backgroundColor = .thirdColor
            self.nextButton.isHidden = false
        }

        takeScreenshot(of: self.view)
    }
    
    @objc func sendFileButton() {
        let params: [String: Any] = ["time": timeString]
        let endPoint = UserShopEndPoint.sendFileExecel(params: params)
        self.showLoading()
        APIService.request(endPoint: endPoint) { [weak self] apiResponse in
            guard let self = self else { return }
            self.hideLoading()
            AlertManager.shared.showToast(message: "Đã gửi file vào email, bạn vui lòng kiểm tra")
        } onFailure: { erorr in
            self.hideLoading()
        } onRequestFail: {
            self.hideLoading()
        }
    }
    
    private func layoutNextButton() {
        self.view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
                .offset(-dimension.normalMargin)
            make.height.equalTo(dimension.defaultHeightButton)
            make.left.equalToSuperview()
                .offset(dimension.normalMargin)
            make.width.equalTo(widthScreen)
        }
    }
    
    private func layoutSendButton() {
        self.view.addSubview(sendButton)
        sendButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
                .offset(-dimension.normalMargin)
            make.height.equalTo(dimension.defaultHeightButton)
            make.right.equalToSuperview()
                .offset(-dimension.normalMargin)
            make.width.equalTo(widthScreen)
        }
    }
    
    private func layoutGeneralTitleLabel() {
        self.view.addSubview(generalTitleLabel)
        generalTitleLabel.snp.makeConstraints { make in
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide)
                    .offset(dimension.normalMargin)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
                    .offset(dimension.normalMargin)
            }
            make.left.right
                .equalToSuperview()
                .inset(dimension.normalMargin)
        }
    }
    
    private func layoutFormTitleLabel() {
        self.view.addSubview(timeTitleLabel)
        timeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(generalTitleLabel.snp.bottom)
                .offset(dimension.mediumMargin)
            make.left.equalTo(generalTitleLabel)
            make.right.equalToSuperview()
        }
    }
    
    private func layoutKeyTitleLabel() {
        self.view.addSubview(keyTitleLabel)
        keyTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(timeTitleLabel.snp.bottom)
                .offset(dimension.mediumMargin)
            make.left.equalToSuperview()
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutValueTitleLabel() {
        self.view.addSubview(valueTitleLabel)
        valueTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(keyTitleLabel)
            make.left.equalTo(keyTitleLabel.snp.right)
                .offset(dimension.largeMargin_42)
        }
    }
    
    private func layoutTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
                .inset(dimension.normalMargin)
            make.top.equalTo(keyTitleLabel.snp.bottom)
            make.bottom.equalTo(nextButton.snp.top)
        }
    }
}

// MARK: - UITableViewDelegate

extension SemmoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}

// MARK: - UITableViewDataSource
extension SemmoreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        return charts.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SeeMoreTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let chart = charts[indexPath.row]
        if self.selectedOrderTypes == .money {
            cell.configTitle(keyTitle: String(Int(chart.orginX)), valueTitle: (chart.orgirnY * 1000000).currencyFormatVN)
        } else {
            cell.configTitle(keyTitle: String(Int(chart.orginX)), valueTitle: String(Int(chart.orgirnY)))
        }
        if indexPath.row % 2 == 0{
            cell.keyCoverView.backgroundColor = UIColor.lightBackground
            cell.valueCoverView.backgroundColor = UIColor.lightBackground
        } else {
            cell.keyCoverView.backgroundColor = UIColor.white
            cell.valueCoverView.backgroundColor = UIColor.white
        }
        return cell
    }
}
