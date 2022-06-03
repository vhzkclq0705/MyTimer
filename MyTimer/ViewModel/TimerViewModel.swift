//
//  TimerViewModel.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/30.
//

import Foundation
import UIKit

// ViewModel for main view
class TimerViewModel {
    
    let manager = TimerManager.shared
    var sections = [Section]()
    
    // MARK: - Funcs for UI
    var numOfSections: Int {
        return sections.count
    }
    
    func numOfTimers(_ section: Int) -> Int {
        return sections[section].timers.count
    }
    
    func sectionTitle(_ section: Int) -> String {
        return sections[section].title
    }
    
    func sectionColor(_ section: Int) -> UIColor {
        let num = section % 7 + 1
        return Colors.color(num)
    }
    
    func timerInfo(_ indexPath: IndexPath) -> Timer {
        return sections[indexPath.section].timers[indexPath.row - 1]
    }
    
    // MARK: - Funcs for delete Section and Timer
    func deleteSection(_ section: Section) {
        sections = sections.filter { $0 != section }
        save()
    }
    
    func deleteTimer(section: Int, timer: Timer) {
        sections[section].timers = sections[section].timers.filter { $0 != timer }
        save()
    }
    
    // MARK: - Funcs for save and load data
    func save() {
        manager.sections = sections
        manager.save()
    }
    
    func load() {
        manager.load()
        sections = manager.sections
    }
}
