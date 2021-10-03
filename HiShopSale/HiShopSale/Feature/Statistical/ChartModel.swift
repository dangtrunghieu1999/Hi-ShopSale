//
//  ChartModel.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 10/08/2021.
//

import UIKit
import SwiftyJSON
import Charts

class DataChart: NSObject, JSONParsable {
    
    var data: [BarChartDataEntry] = []
    var params: [Chart]          = []
    var general: Double           = 0.0
    
    required override init() {}
    
    required init(json: JSON) {
        self.data      = json["data"].arrayValue.map{ Chart(json: $0).entryChart}
        self.params    = json["data"].arrayValue.map{ Chart(json: $0)}
        self.general   = json["general"].doubleValue
    }
}

class Chart: NSObject, JSONParsable {
    
    var orginX: Double              = 0
    var orgirnY: Double             = 0.0
    var entryChart                  = BarChartDataEntry()
    var title                       = ""
    required override init() {}
    
    required init(json: JSON) {
        self.orginX     = json["time"].doubleValue
        self.orgirnY    = json["total"].doubleValue
        self.entryChart = BarChartDataEntry(x: self.orginX, y: self.orgirnY)
    }
    
}
