//
//  TimerButton.swift
//  MyTimer
//
//  Created by 권오준 on 2022/06/03.
//

import Foundation
import UIKit

extension UIButton {
    func timerButtons(_ isCancle: Bool) {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor =  .black
        config.background.backgroundColor = .clear
        
        let size: CGFloat = isCancle ? 20 : 40
        config.preferredSymbolConfigurationForImage =  UIImage.SymbolConfiguration(pointSize: size)
        
        self.configuration = config
    }
}
