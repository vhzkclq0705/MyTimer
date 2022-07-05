//
//  UILabel.swift
//  MyTimer
//
//  Created by 권오준 on 2022/06/18.
//

import UIKit

enum Font: String {
    case regular = "Pretendard-Regular"     // 400
    case medium = "Pretendard-Medium"       // 500
    case semibold = "Pretendard-Semibold"   // 600
    case bold = "Pretendard-Bold"           // 700
}

extension UILabel {
    func setLabelStyle(text: String, font: Font, size: CGFloat) {
        self.text = text
        self.font = UIFont(name: font.rawValue, size: size)
    }
    
    func setAddButtonLabel(_ text: String) {
        self.text = text
        self.font = UIFont(name: Font.semibold.rawValue, size: 14)
        self.textColor = .black
        self.alpha = 0
    }
}
