//
//  SetTimerViewModel.swift
//  MyTimer
//
//  Created by 권오준 on 2022/06/03.
//

import Foundation
import UIKit

class SetTimerViewModel {
    
    let timerManager = TimerManager.shared
    let pickerViewManager = PickerViewManager()
    
    
    // MARK: - Funcs for UI
    var numOfComponents: Int {
        pickerViewManager.numOfComponents
    }
    
    func numOfRows(_ component: Int) -> Int {
        pickerViewManager.numOfRows(component)
    }
    
    func componentsLabel(row: Int, component: Int) -> UIView {
        pickerViewManager.componentsLabel(row: row, component: component)
    }
    
    // MARK: - Funcs for set Timer
    func didSelectTime(row: Int, component: Int) {
        pickerViewManager.didSelectTime(row: row, component: component)
    }
    
    func setTimer(_ indexpath: IndexPath) {
        let min = pickerViewManager.time[0]
        let sec = pickerViewManager.time[1]
        timerManager.setTimer(
            section: indexpath.section, index: indexpath.row - 1,
            min: min, sec: sec)
    }
}
