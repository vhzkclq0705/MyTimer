//
//  Timer.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/30.
//

import Foundation

// Model for timer
struct Timer: Codable, Equatable {
    var title: String
    var min: Int
    var sec: Int
}
