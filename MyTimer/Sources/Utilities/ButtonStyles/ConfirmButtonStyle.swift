//
//  ConfirmButtonStyle.swift
//  MyTimer
//
//  Created by 권오준 on 2024-04-26.
//

import UIKit

enum ConfirmButtonStyle {
    case Ok
    case Cancel
}

extension ConfirmButtonStyle {
    
    var title: String {
        return switch self {
        case .Ok: "확인"
        case .Cancel: "취소"
        }
    }
    
    var titleColor: UIColor {
        return switch self {
        case .Ok: .white
        case .Cancel: .CustomColor(.gray3)
        }
    }
    
    var backgroundColor: UIColor {
        return switch self {
        case .Ok: .CustomColor(.purple2)
        case .Cancel: .CustomColor(.gray1)
        }
    }
    
    var corner: CACornerMask {
        return switch self {
        case .Ok: .layerMaxXMaxYCorner
        case .Cancel: .layerMinXMaxYCorner
        }
    }
    
}
