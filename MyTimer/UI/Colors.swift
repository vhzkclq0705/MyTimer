//
//  Colors.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/30.
//

import Foundation
import UIKit

// Enum for custom color
enum Colors: Int, CaseIterable {
    case first
    case second
    case third
    
    // MARK: - Func that return custom colors to UIColor
    static func color(_ num: Int) -> UIColor {
        switch num {
        case 0: return #colorLiteral(red: 0.6274509804, green: 0.568627451, blue: 0.9176470588, alpha: 1)     // Main Color
        case 1: return #colorLiteral(red: 0.7490196078, green: 0.7843137255, blue: 0.8431372549, alpha: 1)     // ▽ Section Colors
        case 2: return #colorLiteral(red: 0.8862745098, green: 0.8235294118, blue: 0.8235294118, alpha: 1)
        case 3: return #colorLiteral(red: 0.8901960784, green: 0.8862745098, blue: 0.7058823529, alpha: 1)
        case 4: return #colorLiteral(red: 0.5461847186, green: 0.7043510675, blue: 0.9663445354, alpha: 1)  // △ Section Colors
                              // Main text Color
        default: return #colorLiteral(red: 0.7019607843, green: 0.4745098039, blue: 0.7019607843, alpha: 1)
        }
    }
}
