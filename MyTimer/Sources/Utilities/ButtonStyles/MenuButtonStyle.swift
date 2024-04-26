//
//  MenuButtonStyle.swift
//  MyTimer
//
//  Created by 권오준 on 2024-04-26.
//

import Foundation

enum MenuButtonStyle {
    case Section
    case Timer
    case Settings
}

extension MenuButtonStyle {
    
    var title: String {
        return switch self {
        case .Section: "섹션 추가"
        case .Timer: "타이머 추가"
        case .Settings: "설정"
        }
    }
    
    var imageName: String {
        return switch self {
        case .Section: "section"
        case .Timer: "timer"
        case .Settings: "settings"
        }
    }
    
}
