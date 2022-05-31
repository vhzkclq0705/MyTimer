//
//  DropDown.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/31.
//

import Foundation
import UIKit
import DropDown

extension AddTimerView {
    func initDropDown() {
        DropDown.appearance().textColor = .darkGray
        DropDown.appearance().selectedTextColor = .black
        DropDown.appearance().backgroundColor = .white
        DropDown.appearance().selectionBackgroundColor = .lightGray
        DropDown.appearance().setupCornerRadius(5)
        dropDown.dismissMode = .automatic
    }
}
