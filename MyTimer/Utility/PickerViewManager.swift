//
//  PickerViewManager.swift
//  MyTimer
//
//  Created by 권오준 on 2022/06/03.
//

import Foundation
import UIKit

class PickerViewManager {
    
    // MARK: - Property
    var rows = [Int](0...59)
    var time = [0, 0]
    let timeUnits = ["분", "초"]
    
    // MARK: - Funcs for UI
    var numOfComponents: Int {
        return 4
    }
    
    func numOfRows(_ component: Int) -> Int {
        return component % 2 == 0 ? rows.count : 1
    }
    
    func componentsLabel(row: Int, component: Int) -> UIView {
        let label = UILabel()
        component % 2 == 0
        ? label.setLabelStyle(
            text: "",
            font: .bold,
            size: 30,
            color: UIColor.CustomColor(.purple4))
        : label.setLabelStyle(
            text: "",
            font: .bold,
            size: 25,
            color: .black)
        label.textAlignment = component % 2 == 0 ? .right : .center
        
        switch component {
        case 0, 2: label.text = "\(rows[row])"
        case 1: label.text = timeUnits[0]
        default: label.text = timeUnits[1]
        }
        
        return label
    }
    
    // MARK: - Func for select time
    func didSelectTime(row: Int, component: Int) {
        if component == 0 {
            time[0] = row
        } else if component == 2 {
            time[1] = row
        }
    }
}
