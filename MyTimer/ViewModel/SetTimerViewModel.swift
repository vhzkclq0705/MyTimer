//
//  SetTimerViewModel.swift
//  MyTimer
//
//  Created by 권오준 on 2022/06/03.
//

import Foundation

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
    
    // MARK: - Set timer
    func didSelectTime(row: Int, component: Int) {
        if component == 0 {
            timer.min = row
        } else if component == 2 {
            timer.sec = row
        }
    }
    
    func checkSetting() -> (Int, MyTimer) {
        let min = timer.min
        let sec = timer.sec
        let setSection: Int = sectionTitles().firstIndex(of: sectionTitle)!
        let addSection: Int = sectionTitles().firstIndex(of: selectedSectionTitle)!

        let updatedTimer = MyTimer(
            id: timer.id,
            title: timerTitle,
            min: min,
            sec: sec)
        
        if addSection == setSection {
            timerManager.setTimer(
                section: setSection,
                id: timer.id,
                title: timerTitle,
                min: min,
                sec: sec)
            
            return (setSection, updatedTimer)
        } else {
            timerManager.deleteTimer(
                sectionTitle: sectionTitle,
                timer: timer)
            timerManager.addTimer(
                section: addSection,
                title: timerTitle,
                min: min,
                sec: sec)
            
            return (addSection, updatedTimer)
        }
    }
    
    // MARK: - Load data
    func loadSections() {
        sections = timerManager.sections.map { $0 }
    }
}
