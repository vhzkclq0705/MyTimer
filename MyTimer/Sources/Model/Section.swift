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
    
}
