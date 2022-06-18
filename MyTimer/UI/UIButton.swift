//
//  UIButton.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/31.
//

import Foundation
import UIKit

extension UIButton {
    // Custom main view buttons
    func setupMainViewButtons(_ isMain: Bool) {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = isMain ? .white : Colors.color(0)
        
        config.background.backgroundColor = isMain ? Colors.color(0) : .white
        
        config.cornerStyle = .capsule
        
        let fontSize: CGFloat = isMain ? 35 : 25
        config.preferredSymbolConfigurationForImage =  UIImage.SymbolConfiguration(pointSize: fontSize)
        
        self.configuration = config
        self.alpha = isMain ? 1 : 0
    }
    
    // Custom timer Button
    func setupButtonImage(size: CGFloat, color: UIColor?) {
        var config = UIButton.Configuration.plain()
        if let color = color {
            config.baseForegroundColor =  color
        }
        config.background.backgroundColor = .clear
        
        config.preferredSymbolConfigurationForImage =  UIImage.SymbolConfiguration(pointSize: size, weight: .bold)
        
        self.configuration = config
    }
    
    // Custom detail Button
    func setupDetailButton(_ text: String) {
        self.setTitle(text, for: .normal)
        self.backgroundColor = Colors.color(0)
        self.tintColor = .white
        self.layer.cornerRadius = 5
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
    }
}
