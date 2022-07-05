//
//  UILabel.swift
//  MyTimer
//
//  Created by 권오준 on 2022/06/18.
//

import Foundation
import UIKit

extension UILabel {
    func changeLabelStyle(text: String, size: CGFloat) {
        self.text = text
        self.font = .systemFont(ofSize: size, weight: .bold)
    }
    
}
