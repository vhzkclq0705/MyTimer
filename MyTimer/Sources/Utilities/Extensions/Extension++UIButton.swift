//
//  Extension++UIButton.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/31.
//

import UIKit

extension UIButton {
    
    func setMainButtons(_ style: MenuButtonStyle) {
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
    
    func setConfirmButtons(_ style: ConfirmButtonStyle) {
        let attributedString = NSAttributedString(
            string: style.title,
            attributes: [
                .font: UIFont(name: Font.bold.rawValue, size: 18)!,
                .foregroundColor: style.titleColor
            ]
        )
        
        setAttributedTitle(attributedString, for: .normal)
        backgroundColor = style.backgroundColor
        layer.maskedCorners = style.corner
        layer.cornerRadius = 5
        isUserInteractionEnabled = style == .Cancel
    }
    
    func setSubViewOKButton() {
        setTitle("확인", for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont(name: Font.bold.rawValue, size: 18)
        backgroundColor = UIColor.CustomColor(.purple2)
        layer.cornerRadius = 5
        layer.maskedCorners = .layerMaxXMaxYCorner
        
    }
    
    func setSubViewCancleButton() {
        setTitle("취소", for: .normal)
        setTitleColor(UIColor.CustomColor(.gray3), for: .normal)
        titleLabel?.font = UIFont(name: Font.bold.rawValue, size: 18)
        backgroundColor = UIColor.CustomColor(.gray1)
        layer.cornerRadius = 5
        layer.maskedCorners = .layerMinXMaxYCorner
    }
}
