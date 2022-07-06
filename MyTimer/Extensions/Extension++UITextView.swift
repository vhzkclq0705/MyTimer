//
//  Extension++UITextView.swift
//  MyTimer
//
//  Created by 권오준 on 2022/07/06.
//

import UIKit

extension UITextView {
    func setTextView(_ text: String) {
        self.text = text
        self.textColor = UIColor.CustomColor(.gray1)
        self.backgroundColor = .white
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.CustomColor(.gray1).cgColor
        self.font = UIFont(name: Font.regular.rawValue, size: 16)
        self.textContainerInset = UIEdgeInsets(
            top: 15,
            left: 12,
            bottom: 15,
            right: 12)
    }
}
