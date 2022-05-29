//
//  TimerViewModel.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/30.
//

import Foundation

class TimerViewModel {
    
    var sections = [Int : [Timer]]()
    var sectionTitles = [String]()
    
    var numOfSections: Int {
        return sections.count
    }
    
    func numOfTimers(_ section: Int) -> Int {
        return sections[section]!.count
    }
    
    func sectionTitle(_ section: Int) -> String {
        return sectionTitles[section]
    }
}
