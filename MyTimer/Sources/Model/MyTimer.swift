//
//  MyTimer.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/30.
//

import Foundation

// Model for timer
struct MyTimer: Codable, Equatable {
    var id: Int
    var title: String
    var min: Int
    var sec: Int
}

/// Timer model
struct RxMyTimer: Codable, Equatable {
    
    var id: UUID
    var title: String
    var min: Int
    var sec: Int
    
    init(title: String, min: Int, sec: Int) {
        self.id = UUID()
        self.title = title
        self.min = min
        self.sec = sec
    }
    
    static func ==(lhs: RxMyTimer, rhs: RxMyTimer) -> Bool {
        return lhs.id == rhs.id
    }
    
}
