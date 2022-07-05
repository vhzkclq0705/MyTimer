//
//  UIColor.swift
//  MyTimer
//
//  Created by 권오준 on 2022/07/06.
//

import UIKit

enum Colors {
    case purple1
    case purple2
    case purple3
    case purple4
    case purple5
    case red
    case gray1
    case gray2
    case gray3
}

extension UIColor {
    static func CustomColor(_ color: Colors) -> UIColor {
        switch color {
        case .purple1: return #colorLiteral(red: 0.7821971774, green: 0.7565466762, blue: 0.969376266, alpha: 1)
        case .purple2: return #colorLiteral(red: 0.6156862745, green: 0.568627451, blue: 0.8941176471, alpha: 1)
        case .purple3: return #colorLiteral(red: 0.4823529412, green: 0.4117647059, blue: 0.9019607843, alpha: 1)
        case .purple4: return #colorLiteral(red: 0.3803921569, green: 0.2901960784, blue: 0.9176470588, alpha: 1)
        case .purple5: return #colorLiteral(red: 0.262745098, green: 0.1490196078, blue: 0.9254901961, alpha: 1)
        case .red: return #colorLiteral(red: 0.9725490196, green: 0.3176470588, blue: 0.3176470588, alpha: 1)
        case .gray1: return #colorLiteral(red: 0.8823529412, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
        case .gray2: return #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        case .gray3: return #colorLiteral(red: 0.5764705882, green: 0.5764705882, blue: 0.5764705882, alpha: 1)
        }
    }
}
