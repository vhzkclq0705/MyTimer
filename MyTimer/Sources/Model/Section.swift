//
//  Section.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/30.
//

import Foundation
import RxDataSources

/// Section Model
struct Section: Codable {
    var id: UUID
    var title: String
    var isExpanded: Bool
    var createdDate: Date
    var items: [MyTimer]
    
    init(id: UUID, title: String, isExpanded: Bool, createdDate: Date, items: [MyTimer]) {
        self.id = id
        self.title = title
        self.isExpanded = isExpanded
        self.createdDate = createdDate
        self.items = items
    }
}

// MARK: - Update

extension Section {
    mutating func updateIsExpanded() {
        self.isExpanded.toggle()
    }
    
    mutating func updateTitle(title: String) {
        self.title = title
    }
}

// MARK: - Rx

extension Section: Equatable, IdentifiableType, AnimatableSectionModelType {
    typealias Identity = UUID
    typealias Item = MyTimer
    
    var identity: UUID {
        return id
    }
    
    init(original: Section, items: [Item]) {
        self = original
        self.items = items
    }
}


/// Section model
struct RxSection {
    
    var id: UUID
    var title: String
    var isExpanded: Bool
    var items: [RxMyTimer]
    
    init(id: UUID, title: String, isExpanded: Bool, items: [RxMyTimer]) {
        self.id = id
        self.title = title
        self.isExpanded = isExpanded
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
    
    func getOneTimer(id: UUID) -> RxMyTimer? {
        return items.first { $0.id == id }
    }
    
    mutating func addTimer(title: String, min: Int, sec: Int) {
        let timer = RxMyTimer(id: UUID(), title: title, min: min, sec: sec)
        items.append(timer)
    }
    
    mutating func updateTimer(id: UUID, title: String, min: Int, sec: Int) {
        if let index = items.firstIndex(where: { $0.id == id }) {
            items[index].updateTimer(title: title, min: min, sec: sec)
        }
    }
    
    mutating func deleteTimer(id: UUID) {
        items.removeAll(where: { $0.id == id })
    }
    
}
