//
//  Section.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/30.
//

import Foundation
import UIKit

// Model for Section
struct Section: Codable, Equatable {
    var title: String
    var timers = [Timer]()
}