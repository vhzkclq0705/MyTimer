//
//  UIextField.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/31.
//

import Foundation
import UIKit

extension UITextField {
    // Custom TextField
    func setupDetailTextField(_ title: String) {
        self.backgroundColor = .white
        self.textColor = .black
        self.font = .systemFont(ofSize: 20, weight: .bold)
        self.addLeftPadding()
        
        self.attributedPlaceholder = NSAttributedString(
            string: title,
            attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        self.layer.borderColor = Colors.color(0).cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 5
    }
    
    // Add left padding in TextField
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: 5,
            height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
