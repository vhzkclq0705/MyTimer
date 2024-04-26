//
//  Extension++UIButton.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/31.
//

import UIKit

enum ButtonStyle {
    case Section
    case Timer
    case Settings
}

extension ButtonStyle {
    
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

extension UIButton {
    
    func setMainButtons(_ style: ButtonStyle) {
        let attributedString = NSAttributedString(
            string: style.title,
            attributes: [
                .font: UIFont(name: Font.semibold.rawValue, size: 14)!,
                .foregroundColor: UIColor.white
            ])
        
        configuration = UIButton.Configuration.filled()
        configuration?.attributedTitle = AttributedString(attributedString)
        configuration?.baseBackgroundColor = .CustomColor(.purple2)
        configuration?.cornerStyle = .capsule
        configuration?.imagePlacement = .trailing
        configuration?.imagePadding = 10
        
        setImage(UIImage(named: style.imageName), for: .normal)
        alpha = 0
    }
    
    func setSubViewOKButton() {
        self.setTitle("확인", for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont(name: Font.bold.rawValue, size: 18)
        self.backgroundColor = UIColor.CustomColor(.purple2)
        self.layer.cornerRadius = 5
        self.layer.maskedCorners = .layerMaxXMaxYCorner
    }
    
    func setSubViewCancleButton() {
        self.setTitle("취소", for: .normal)
        self.setTitleColor(UIColor.CustomColor(.gray3), for: .normal)
        self.titleLabel?.font = UIFont(name: Font.bold.rawValue, size: 18)
        self.backgroundColor = UIColor.CustomColor(.gray1)
        self.layer.cornerRadius = 5
        self.layer.maskedCorners = .layerMinXMaxYCorner
    }
}
