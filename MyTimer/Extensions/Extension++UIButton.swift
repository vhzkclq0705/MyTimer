//
//  Extension++UIButton.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/31.
//

import UIKit

extension UIButton {
    func setMainButtons(_ name: String) {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.baseBackgroundColor = UIColor.CustomColor(.purple2)
        
        self.configuration = config
        self.setImage(UIImage(named: name), for: .normal)
        self.alpha = 0
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
