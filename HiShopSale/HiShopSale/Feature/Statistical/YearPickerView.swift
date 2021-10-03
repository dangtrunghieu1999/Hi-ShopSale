//
//  YearPickerView.swift
//  HiShopSale
//
//  Created by Bee_MacPro on 11/08/2021.
//

import UIKit

class YearPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var years = [Int]()

    var year = Calendar.current.component(.year, from: Date()) {
        didSet {
            if let firstYearIndex = years.firstIndex(of: year) {
                selectRow(firstYearIndex, inComponent: 0, animated: true)
            }
        }
    }
    
    var onDateSelected: ((_ year: Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }
    
    func commonSetup() {
        // population years
        var years: [Int] = []
        if years.count == 0 {
            var year = Calendar(identifier: .gregorian).component(.year, from: Date())
            for _ in 1...15 {
                years.append(year)
                year += 1
            }
        }
        self.years = years
       
        
        delegate = self
        dataSource = self
    }
    
    // Mark: UIPicker Delegate / Data Source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(years[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return years.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let year = years[selectedRow(inComponent: 0)]
        if let block = onDateSelected {
            block( year)
        }
        
        self.year = year
    }
}
