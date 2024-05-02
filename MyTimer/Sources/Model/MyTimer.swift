//
//  MyTimer.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/30.
//

import Foundation
import RxDataSources

// Model for timer
struct MyTimer: Codable, Equatable {
    var id: Int
    var title: String
    var min: Int
    var sec: Int
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
