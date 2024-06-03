//
//  TimerListEnums.swift
//  MyTimer
//
//  Created by 권오준 on 2024-06-03.
//

import Foundation

/// Enum for button type of CollectionView HeaderView
enum HeaderButtonType {
    case Expand
    case Update
}

/// Enum for animations of Menu Button
enum ButtonAnimation {
    case First
    case Second
    case Third
}

/// Enum for type of Menu Button
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

