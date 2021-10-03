//
//  FilterViewModel.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 11/08/2021.
//

import Foundation

enum FilterCouponOrderType: Int {
    case money          = 0
    case order          = 1
    
    var description: String {
        switch self {
        case .money:
            return "Tổng doanh thu"
        case .order:
            return "Tổng đơn hàng"
        }
    }
    
    var key: String {
        switch self {
        case .money:
            return "revenue"
        case .order:
            return "totalOrder"
        }
    }
    
    var title: String {
        switch self {
        case .money:
            return "Doanh thu (M)"
        case .order:
            return "Đơn hàng"
        }
    }
    
    var detail: String {
        switch self {
        case .money:
            return "Doanh thu"
        case .order:
            return "Đơn hàng"
        }
    }
    
    var label: String {
        switch self {
        case .money:
            return "Thống kê doanh thu"
        case .order:
            return "Thống kê đơn hàng"
        }
    }
}

enum FilterCupponByValidation: Int {
    case month          = 0
    case year           = 1
    
    var description: String {
        switch self {
        case .month:
            return "Tháng"
        case .year:
            return "Năm"
        }
    }
    
    var title: String {
        switch self {
        case .month:
            return "Ngày trong tháng"
        case .year:
            return "Tháng trong năm"
        }
    }
    
    var value: String {
        switch self {
        case .month:
            return "Ngày"
        case .year:
            return "Tháng"
        }
    }
}

// MARK: -

class FilterCouponViewModel: NSObject {
    
    // MARK: - Varibles
    
    private (set) var selectedOrderTypes: [FilterCouponOrderType] = [.money]
    private (set) var selectedValidations: [FilterCupponByValidation] = [.month]
    private (set) var timeFilter = ""
    
    func setTimeFilter(time: String) {
        self.timeFilter = time
    }
    
    // MARK: - Public methods
    
    /// Return Bool indicate should reload data
    @discardableResult
    func didSelectOrderType(_ orderType: FilterCouponOrderType) -> Bool {
        if orderType == .money {
            if self.selectedOrderTypes.contains(orderType) {
                return false
            } else {
                self.selectedOrderTypes.removeAll()
                self.selectedOrderTypes.append(orderType)
                return true
            }
        } else {
            if let index = self.selectedOrderTypes.firstIndex(of: .money) {
                self.selectedOrderTypes.remove(at: index)
                self.selectedOrderTypes.append(orderType)
                return true
            } else {
                if let selectedOrderIndex = self.selectedOrderTypes.firstIndex(of: orderType) {
                    if self.selectedOrderTypes.count > 1 {
                        self.selectedOrderTypes.remove(at: selectedOrderIndex)
                        return true
                    } else {
                        return false
                    }
                } else {
                    self.selectedOrderTypes.append(orderType)
                    return true
                }
            }
        }
    }
    
    /// Return Bool indicate should reload data
    @discardableResult
    func didSelectValidationType(_ validationType: FilterCupponByValidation) -> Bool {
        if validationType == .month {
            if self.selectedValidations.contains(validationType) {
                return false
            } else {
                self.selectedValidations.removeAll()
                self.selectedValidations.append(validationType)
                return true
            }
        } else {
            if let index = self.selectedValidations.firstIndex(of: .month) {
                self.selectedValidations.remove(at: index)
                self.selectedValidations.append(validationType)
                return true
            } else {
                if let selectedValidationIndex = self.selectedValidations.firstIndex(of: validationType) {
                    if self.selectedValidations.count > 1 {
                        self.selectedValidations.remove(at: selectedValidationIndex)
                        return true
                    } else {
                        return false
                    }
                } else {
                    self.selectedValidations.append(validationType)
                    return true
                }
            }
        }
    }
    
    func isSelectedCell(at indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            guard let orderType = FilterCouponOrderType(rawValue: indexPath.row) else {
                return false
            }
            return self.selectedOrderTypes.contains(orderType)
        } else {
            guard let validationType = FilterCupponByValidation(rawValue: indexPath.row) else {
                return false
            }
            return self.selectedValidations.contains(validationType)
        }
    }
    
}
