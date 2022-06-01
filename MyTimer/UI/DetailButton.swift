//
//  DetailButton.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/31.
//

import Foundation
import UIKit

extension UIButton {
    // MARK: Func for custom Button
    func setupDetailButton() {
        self.backgroundColor = Colors.color(0)
        self.tintColor = .white
        self.layer.cornerRadius = 5
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
    }
}
