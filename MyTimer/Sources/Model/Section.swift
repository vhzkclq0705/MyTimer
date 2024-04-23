//
//  Section.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/30.
//

import Foundation

// Model for Section
struct Section: Codable, Equatable {
    var id: Int
    var title: String
    var timers = [MyTimer]()
}

/// Section model
struct RxSection: Codable {
    
    var id: UUID
    var title: String
    var timers: [RxMyTimer]
    
    init(title: String, timers: [RxMyTimer]) {
        self.id = UUID()
        self.title = title
        self.timers = timers
    }
    
}

extension RxSection {
    
    mutating func addTimer(title: String, min: Int, sec: Int) {
        let timer = RxMyTimer(title: title, min: min, sec: sec)
        timers.append(timer)
    }
    
    mutating func updateTimer(id: UUID, title: String, min: Int, sec: Int) {
        if let index = timers.firstIndex(where: { $0.id == id }) {
            timers[index] = RxMyTimer(title: title, min: min, sec: sec)
        }
    }
    
    mutating func deleteTimer(id: UUID) {
        timers.removeAll(where: { $0.id == id })
    }
    
}
