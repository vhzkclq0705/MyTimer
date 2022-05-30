//
//  Section.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/30.
//

import Foundation

struct Section: Codable, Equatable {
    var title: String
    var red: Double
    var green: Double
    var blue: Double
    var timers = [Timer]()
}
