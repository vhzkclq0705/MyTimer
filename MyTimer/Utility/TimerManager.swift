//
//  TimerManager.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/30.
//

import Foundation
import UIKit

// Class for model(Section) management
class TimerManager {
    
    // MARK: - Property
    static let shared = TimerManager()
    var sections = [Section]()
    
    private init() {}
    
    // MARK: - Funcs for Section and Timer
    func addSection(_ title: String) {
        let section = Section(title: title,timers: [])
        
        sections.append(section)
        save()
    }
    
    func addTimer(title: String, min: Int, sec: Int, section: Int) {
        let timer = MyTimer(title: title, min: min, sec: sec)
        sections[section].timers.append(timer)
        save()
    }
    
    func setTimer(section: Int, index: Int, min: Int, sec: Int) {
        sections[section].timers[index].min = min
        sections[section].timers[index].sec = sec
        save()
    }
    
    // MARK: - Funcs for save and load data
    func save() {
        UserDefaults.standard.set(
            try? PropertyListEncoder().encode(sections),
            forKey: "Sections")
        
        print("Save Success!")
    }
    
    func load() {
        guard let data = UserDefaults.standard.data(forKey: "Sections") else { return
        }
        sections = (try? PropertyListDecoder().decode(
            [Section].self,
            from: data)) ?? []
        
        print("Load Success!")
    }
}
