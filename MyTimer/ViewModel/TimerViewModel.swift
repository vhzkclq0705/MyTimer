//
//  TimerViewModel.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/30.
//

import Foundation
import UIKit

class TimerViewModel {
    
    var sections = [Section]()
    
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
        // Convert Double type RGB to CGFloat type
        let red: CGFloat = sections[section].red
        let green: CGFloat = sections[section].green
        let blue: CGFloat = sections[section].blue
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    func timerInfo(section: Int, index: Int) -> Timer {
        return sections[section].timers[index]
    }
    
    func addSection(_ title: String) {
        // Create random color
        let red = drand48()
        let green = drand48()
        let blue = drand48()
        let section = Section(title: title, red: red, green: green, blue: blue, timers: [])
        
        sections.append(section)
        save()
    }
    
    func addTimer(title: String, time: String, section: Int) {
        let timer = Timer(title: title, time: time)
        sections[section].timers.append(timer)
        save()
    }
    
    func deleteSection(_ section: Section) {
        sections = sections.filter { $0 != section }
        save()
    }
    
    func deleteTimer(section: Int, timer: Timer) {
        sections[section].timers = sections[section].timers.filter { $0 != timer }
        save()
    }
    
    func save() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(sections), forKey: "Sections")
        
        print("Save Success!")
    }
    
    func load() {
        guard let data = UserDefaults.standard.data(forKey: "Sections") else { return }
        sections = (try? PropertyListDecoder().decode([Section].self, from: data)) ?? []
        
        print("Load Success!")
    }
}
