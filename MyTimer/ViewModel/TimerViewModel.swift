//
//  TimerViewModel.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/30.
//

import Foundation
import UIKit

// ViewModel for TimerListVC
class TimerViewModel {
    
    // MARK: - Property
    let manager = TimerManager.shared
    var sections = [Section]()
    
    // MARK: - UI
    var numOfSections: Int {
        return sections.count
    }
    
    func numOfTimers(_ section: Int) -> Int {
        return sections[section].timers.count
    }
    
    func sectionTitle(_ section: Int) -> String {
        return sections[section].title
    }
    
    func timerInfo(_ indexPath: IndexPath) -> MyTimer {
        return sections[indexPath.section].timers[indexPath.row - 1]
    }
    
    // MARK: - Load data
    func load() {
        manager.load()
        sections = manager.sections
    }
}
