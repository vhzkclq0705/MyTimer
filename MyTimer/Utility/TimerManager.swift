//
//  TimerManager.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/30.
//

import Foundation
import UIKit

class TimerManager {
    static let shared = TimerManager()
    
    private init() {}
    
    var sections = [Section]()
    
    func addSection(_ title: String) {
        let section = Section(title: title,timers: [])
        
        sections.append(section)
        save()
    }
    
    func addTimer(title: String, min: Int, sec: Int, section: Int) {
        let timer = Timer(title: title, min: min, sec: sec)
        sections[section].timers.append(timer)
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
