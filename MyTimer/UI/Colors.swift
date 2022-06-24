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
    // Section Colors
    case first
    case second
    case third
    case fourth
    
    // Return custom colors to UIColor
    static func color(_ num: Int) -> UIColor {
        switch num {
        case 0: return #colorLiteral(red: 0.6274509804, green: 0.568627451, blue: 0.9176470588, alpha: 1)      // Main color
        case 1: return #colorLiteral(red: 0.9792160392, green: 0.8055928349, blue: 0.7913253903, alpha: 1)      // ▽ Section colors
        case 2: return #colorLiteral(red: 0.7435396314, green: 0.8954974413, blue: 0.8448426723, alpha: 1)
        case 3: return #colorLiteral(red: 0.9426876903, green: 0.9449196458, blue: 0.7034451962, alpha: 1)
        case 4: return #colorLiteral(red: 0.8016375899, green: 0.8839026093, blue: 0.9350808263, alpha: 1)      // △ Section colors
        case 5: return #colorLiteral(red: 0.09411764706, green: 0.09411764706, blue: 0.09411764706, alpha: 1)      // Main View background color
        case 6: return #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)      // TableView separator color
        case 7: return #colorLiteral(red: 0.7019607843, green: 0.4745098039, blue: 0.7019607843, alpha: 1)      // Main text Color
        default: return .clear
        }
    }
}
