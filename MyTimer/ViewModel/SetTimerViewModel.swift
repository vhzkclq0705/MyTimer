//
//  SetTimerViewModel.swift
//  MyTimer
//
//  Created by 권오준 on 2022/06/03.
//

import UIKit

// ViewModel for SetTimerVC
class SetTimerViewModel {
    
    // MARK: - Property
    let timerManager = TimerManager.shared
    let pickerViewManager = PickerViewManager()
    var sections = [Section]()
    var sectionTitle: String!
    var selectedSectionTitle: String!
    var timer: MyTimer!
    var timerTitle: String!
    
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
    
    func sectionTitles() -> [String] {
        return sections.map { $0.title }
    }
    
    // MARK: - Funcs for set Timer
    func didSelectTime(row: Int, component: Int) {
        pickerViewManager.didSelectTime(row: row, component: component)
    }
    
    func checkSetting(_ timer: MyTimer) {
        let min = pickerViewManager.time[0]
        let sec = pickerViewManager.time[1]
        let setSection: Int = sectionTitles().firstIndex(of: sectionTitle)!
        let addSection: Int = sectionTitles().firstIndex(of: selectedSectionTitle)!

        addSection == setSection
        ? setTimer(
            section: setSection,
            timer: timer,
            min: min,
            sec: sec)
        : timerManager.addTimer(
            section: addSection,
            title: timerTitle,
            min: min,
            sec: sec)
    }
    
    func setTimer(section: Int, timer: MyTimer, min: Int, sec: Int) {
        let timerIndex: Int = sections[section].timers.firstIndex(of: timer)!
        
        timerManager.setTimer(
            section: section,
            index: timerIndex,
            title: timerTitle,
            min: min,
            sec: sec)
    }
    
    // MARK: - Load data
    func loadSections() {
        sections = timerManager.sections.map { $0 }
    }
}
