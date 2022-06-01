//
//  Colors.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/30.
//

import Foundation
import UIKit

// Enum for custom color
enum Colors: Int {
    case main
    case first
    case second
    case third
    case fourth
    case fifth
    case sixth
    case seventh
}

// MARK: - Func that return custom colors to UIColor
extension Colors {
    static func color(_ num: Int) -> UIColor {
        switch num {
        case 0: return #colorLiteral(red: 1, green: 0.7764705882, blue: 1, alpha: 1)     // Main Color
        case 1: return #colorLiteral(red: 1, green: 0.6784313725, blue: 0.6784313725, alpha: 1)     // ▽ Section Colors
        case 2: return #colorLiteral(red: 1, green: 0.8392156863, blue: 0.6470588235, alpha: 1)
        case 3: return #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        case 4: return #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        case 5: return #colorLiteral(red: 0.6613282561, green: 0.9681838155, blue: 1, alpha: 1)
        case 6: return #colorLiteral(red: 0.6274509804, green: 0.768627451, blue: 1, alpha: 1)
        case 7: return #colorLiteral(red: 0.7411764706, green: 0.6980392157, blue: 1, alpha: 1)     // △ Section Colors
                              // Main text Color
        default: return #colorLiteral(red: 0.7019607843, green: 0.4745098039, blue: 0.7019607843, alpha: 1)
        }
    }
}
