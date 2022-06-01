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
    
    static let shared = TimerManager()
    
    private init() {}
    
    var sections = [Section]()
    
    // MARK: - Funcs for add Section and Timer
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
    
    // MARK: - Funcs for save and load data
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
