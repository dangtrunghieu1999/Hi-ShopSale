//
//  StatisticalViewController.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 26/05/2021.
//

import UIKit
import Charts
import Alamofire
import SwiftyJSON

class StatisticalViewController: BaseViewController, ChartViewDelegate {
    
    var yValues: [BarChartDataEntry] = []
    var charts: [Chart] = []
    var dataChart = DataChart()
    var typeString = "revenue"
    var timeString = Date().serverMonthFormat
    var titleLabel = ""
    var titleDate = ""
    var general: Double = 0.0
    
    private (set) var selectedOrderTypes: FilterCouponOrderType = .money
    private (set) var selectedValidations: FilterCupponByValidation = .month
    
    lazy var barChartView: BarChartView = {
        let chartView = BarChartView()
        chartView.animate(xAxisDuration: 2.5)
        chartView.rightAxis.enabled = false
        chartView.backgroundColor = .white
        
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: FontSize.h3.rawValue)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .second
        yAxis.axisLineColor = .second
        yAxis.labelPosition = .outsideChart
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = .boldSystemFont(ofSize: FontSize.h3.rawValue)
        chartView.xAxis.setLabelCount(6, force: false)
        chartView.xAxis.labelTextColor = .second
        chartView.xAxis.axisLineColor = .second
        return chartView
    }()
    
    fileprivate lazy var verticalTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: FontSize.h3.rawValue)
        return label
    }()
    
    fileprivate lazy var horizontalTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: FontSize.h3.rawValue)
        return label
    }()
    
    fileprivate lazy var generalTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.thirdColor
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        return label
    }()
    
    fileprivate lazy var seeTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.thirdColor
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        label.text = "Thông số chi tiết"
        return label
    }()
    
    private let lineView: BaseView = {
        let view = BaseView()
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    fileprivate lazy var formTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        label.text = "Hình thức: " + selectedOrderTypes.description
        return label
    }()
    
    fileprivate lazy var timeTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.textAlignment = .left
        label.text = "Thời gian: " + timeString
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        return label
    }()
    
    let pulleyView: FilterStatisticalView = {
        let view = FilterStatisticalView()
        return view
    }()
    
    fileprivate lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Xem chi tiết", for: .normal)
        button.backgroundColor = UIColor.thirdColor
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = dimension.cornerRadiusSmall
        button.layer.masksToBounds = true
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(tapOnNext),
                         for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = TextManager.statistics
        self.layoutGeneralTitleLabel()
        self.layoutNextButton()
        self.layoutTimeTitleLabel()
        self.layoutFormTitleLabel()
        self.layoutLineView()
        self.layoutSeeMoreTitleLabel()
        self.layoutChartView()
        self.layoutVerticalTitleLabel()
        self.layoutHorizontalTitleLabel()
        self.setupPulleyView()
        self.navigationItem.rightBarButtonItem = filterButtonItem
        self.requestAPIChart()
        self.pulleyView.delegate = self
    }
    
    func requestAPIChart() {
        let params:  [String: Any] = ["type": typeString,
                                      "time": timeString]
        
        let endPoint = UserShopEndPoint.getStatistical(params: params)
        APIService.request(endPoint: endPoint) { [weak self] apiResponse in
            guard let self = self else { return }
            self.dataChart = apiResponse.toObject(DataChart.self) ?? DataChart()
            self.yValues = self.dataChart.data
            self.charts = self.dataChart.params
            self.configData()
            self.setData()
        } onFailure: { error in
            
        } onRequestFail: {
        }
    }
    
    @objc private func tapOnNext() {
        let vc = SemmoreViewController()
        vc.title = "Chi tiết thống kê"
        vc.selectedOrderTypes = self.selectedOrderTypes
        vc.selectedValidations = self.selectedValidations
        vc.timeString = self.timeString
        vc.charts = charts
        vc.typeString = self.typeString
        vc.generalTite = generalTitleLabel.text ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setData() {
        let set1 = BarChartDataSet(entries: yValues, label: self.titleLabel)
        set1.colors = ChartColorTemplates.joyful()
        let data = BarChartData(dataSet: set1)
        barChartView.data = data
    }
    
    func configData() {
        self.verticalTitleLabel.text = selectedOrderTypes.title
        self.horizontalTitleLabel.text = selectedValidations.title
        self.titleLabel = selectedOrderTypes.label
        if selectedOrderTypes == .money {
            self.generalTitleLabel.text = selectedOrderTypes.description + ": \((self.dataChart.general).currencyFormatVN)"
        } else {
            self.generalTitleLabel.text = selectedOrderTypes.description + ": \(Int(self.dataChart.general))" + " đơn"
        }
    }
    
    override func touchInFilter() {
        if self.pulleyView.isShow {
            self.pulleyView.hidePulley()
        } else {
            self.pulleyView.showPulley()
        }
    }
    
    private func layoutGeneralTitleLabel() {
        self.view.addSubview(generalTitleLabel)
        generalTitleLabel.snp.makeConstraints { make in
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide)
                    .offset(dimension.largeMargin)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
                    .offset(dimension.largeMargin)
            }
            make.centerX.equalToSuperview()
            make.left.right
                .equalToSuperview()
                .inset(dimension.normalMargin)
        }
    }
    
    private func layoutNextButton() {
        self.view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
                .inset(dimension.normalMargin)
            make.height.equalTo(Dimension.shared.largeHeightButton)
            make.bottom.equalToSuperview()
                .offset(-dimension.largeMargin)
        }
    }
    
    private func layoutTimeTitleLabel() {
        self.view.addSubview(timeTitleLabel)
        timeTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
                .offset(dimension.normalMargin)
            make.right.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top)
                .offset(-dimension.largeMargin)
        }
    }
    
    private func layoutFormTitleLabel() {
        self.view.addSubview(formTitleLabel)
        formTitleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(timeTitleLabel.snp.top)
                .offset(-dimension.mediumMargin)
            make.left.equalTo(timeTitleLabel)
            make.right.equalToSuperview()
        }
    }
    
    private func layoutLineView() {
        self.view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.bottom.equalTo(formTitleLabel.snp.top)
                .offset(-dimension.mediumMargin)
            make.height.equalTo(2)
            make.left.right.equalToSuperview()
                .inset(dimension.normalMargin)
        }
    }
    
    private func layoutSeeMoreTitleLabel() {
        self.view.addSubview(seeTitleLabel)
        seeTitleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(lineView.snp.top)
                .offset(-dimension.mediumMargin)
            make.left.equalToSuperview()
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutChartView() {
        self.view.addSubview(barChartView)
        barChartView.snp.makeConstraints { make in
            make.top.equalTo(generalTitleLabel.snp.bottom)
                .offset(dimension.largeMargin)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(seeTitleLabel.snp.top)
                .offset(-dimension.normalMargin)
        }
    }
    
    private func layoutVerticalTitleLabel() {
        self.view.addSubview(verticalTitleLabel)
        verticalTitleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(barChartView.snp.top)
            make.left.equalToSuperview()
                .offset(dimension.largeMargin)
        }
    }
    
    private func layoutHorizontalTitleLabel() {
        self.view.addSubview(horizontalTitleLabel)
        horizontalTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(barChartView.snp.bottom)
                .offset(-dimension.normalMargin)
            make.right.equalToSuperview()
                .offset(-dimension.largeMargin)
        }
    }
    
    private func setupPulleyView() {
        self.view.addSubview(self.pulleyView)
        self.pulleyView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension StatisticalViewController: FilterStatisticalViewDelegate {
    func handleFilterSelected(type: String, time: String,
                              filterType: FilterCouponOrderType,
                              typeValidation: FilterCupponByValidation) {
        self.typeString = type
        self.timeString = time
        self.selectedOrderTypes = filterType
        self.selectedValidations = typeValidation
        self.requestAPIChart()
        self.formTitleLabel.text = "Hình thức: " + selectedOrderTypes.description
        self.timeTitleLabel.text = "Thời gian: " + timeString
    }
}
