//
//  TimerManager.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/30.
//

import UIKit

// Class for model(Section) management
class TimerManager {
    
    // MARK: - Property
    static let shared = TimerManager()
    
    var lastSectionID: Int = 0
    var sections = [Section]()
    
    private init() {}
    
    // MARK: - Sections
    func addSection(_ title: String) {
        let nextSectionID = lastSectionID + 1
        lastSectionID = nextSectionID
        
        let section = Section(
            id: nextSectionID,
            title: title,
            timers: [])
        
        sections.append(section)
        
        save()
    }
    
    func setSection(section: Section, title: String) {
        guard let index: Int = sections.firstIndex(of: section) else {
            return
        }
        
        sections[index].title = title
        
        save()
    }
    
    func deleteSection(_ section: Section) {
        sections = sections.filter { $0.id != section.id }
        
        save()
    }
    
    // MARK: - Timers
    func addTimer(section: Int, title: String, min: Int, sec: Int) {
        let lastTimerID = sections[section].timers.last?.id ?? 0
        let nextTimerID = lastTimerID + 1
        let timer = MyTimer(
            id: nextTimerID,
            title: title,
            min: min,
            sec: sec)
        
        sections[section].timers.append(timer)
        
        save()
    }
    
    func setTimer(section: Int, id: Int, title: String, min: Int, sec: Int) {
        let timers = sections[section].timers
        let timer = (timers.filter { $0.id == id })[0]
        guard let index: Int = timers.firstIndex(of: timer) else {
            return
        }
        let setTimer = MyTimer(id: id, title: title, min: min, sec: sec)
        
        sections[section].timers[index] = setTimer
        
        save()
    }
    
    func deleteTimer(sectionTitle: String, timer: MyTimer) {
        let section = (sections.filter { $0.title == sectionTitle })[0]
        guard let index: Int = sections.firstIndex(of: section) else {
            return
        }
        
        sections[index].timers = sections[index].timers.filter {
            $0.id != timer.id
        }
        
        save()
    }
    
    // MARK: - Save and load data
    func save() {
        UserDefaults.standard.set(
            try? PropertyListEncoder().encode(sections),
            forKey: "Sections")
    }
    
    func load() {
        guard let data = UserDefaults.standard.data(forKey: "Sections") else { return
        }
        
        sections = (try? PropertyListDecoder().decode(
            [Section].self,
            from: data)) ?? []
        
        lastSectionID = sections.last?.id ?? 0
    }
}
