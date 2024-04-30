//
//  Section.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/30.
//

import Foundation
import RxDataSources

// Model for Section
struct Section: Codable, Equatable {
    var id: Int
    var title: String
    var timers = [MyTimer]()
}

/// Section model
struct RxSection {
    
    var id: UUID
    var title: String
    var isExpanded: Bool
    var items: [RxMyTimer]
    
    init(title: String, items: [RxMyTimer]) {
        self.id = UUID()
        self.title = title
        self.isExpanded = true
        self.items = items
    }
    
}

// RxDataSources
extension RxSection: Codable, AnimatableSectionModelType {
 
    typealias Identity = UUID
    typealias Item = RxMyTimer
    
    var identity: UUID {
        return id
    }
    
    init(original: RxSection, items: [Item]) {
        self = original
        self.items = items
    }
    
}

extension RxSection {
    
    mutating func addTimer(title: String, min: Int, sec: Int) {
        let timer = RxMyTimer(title: title, min: min, sec: sec)
        items.append(timer)
    }
    
    mutating func updateTimer(id: UUID, title: String, min: Int, sec: Int) {
        if let index = items.firstIndex(where: { $0.id == id }) {
            items[index] = RxMyTimer(title: title, min: min, sec: sec)
        }
    }
    
    mutating func deleteTimer(id: UUID) {
        items.removeAll(where: { $0.id == id })
    }
    
}
