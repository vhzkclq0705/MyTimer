//
//  AddTimerViewModel.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/31.
//

import UIKit

// ViewModel for AddTimerVC
class AddTimerViewModel {
    
    // MARK: - Property
    let timerManager = TimerManager.shared
    let pickerViewManager = PickerViewManager()
    var sections = [String]()
    var section: Int = 0
    
    // MARK: - UI
    var numOfComponents: Int {
        pickerViewManager.numOfComponents
    }
    
    func numOfRows(_ component: Int) -> Int {
        pickerViewManager.numOfRows(component)
    }
    
    func componentsLabel(row: Int, component: Int) -> UIView {
        pickerViewManager.componentsLabel(row: row, component: component)
    }
    
    // MARK: - Timer
    func didSelectTime(row: Int, component: Int) {
        pickerViewManager.didSelectTime(row: row, component: component)
    }
    
    func addTimer(title: String) {
        let time = pickerViewManager.time
        timerManager.addTimer(
            section: section,
            title: title,
            min: time[0],
            sec: time[1])
    }
    
    // MARK: - Load data
    func loadSections() {
        sections = timerManager.sections.map { $0.title }
    }
}
