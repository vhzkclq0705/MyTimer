//
//  MyTimer.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/30.
//

import Foundation
import RxDataSources

/// Timer Model
struct MyTimer: Codable {
    var sectionID: UUID
    var id: UUID
    var title: String
    var min: Int
    var sec: Int
    var createdDate: Date
    
    init(sectionID: UUID, id: UUID, title: String, min: Int, sec: Int) {
        self.sectionID = sectionID
        self.id = id
        self.title = title
        self.min = min
        self.sec = sec
        self.createdDate = Date()
    }
}

// MARK: - Update

extension MyTimer: Equatable, IdentifiableType {
    mutating func updateTimer(sectionID: UUID, title: String, min: Int, sec: Int) {
        self.sectionID = sectionID
        self.title = title
        self.min = min
        self.sec = sec
    }
}

// MARK: - RxDataSources

extension MyTimer {
    typealias Identity = UUID
    var identity: UUID {
        return id
    }
}


/// Timer model
struct RxMyTimer {
    
    var id: UUID
    var title: String
    var min: Int
    var sec: Int
    
    init(id: UUID, title: String, min: Int, sec: Int) {
        self.id = id
        self.title = title
        self.min = min
        self.sec = sec
    }
    
}

extension RxMyTimer: Codable, Equatable, IdentifiableType {
    
    typealias Identity = UUID
    
    var identity: UUID {
        return id
    }
    
}


extension RxMyTimer {
    
    mutating func updateTimer(title: String, min: Int, sec: Int) {
        self.title = title
        self.min = min
        self.sec = sec
    }
    
}
