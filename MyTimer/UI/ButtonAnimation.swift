//
//  ButtonAnimation.swift
//  MyTimer
//
//  Created by 권오준 on 2022/06/18.
//

import Foundation
import UIKit

extension TimerListVC {
    // AddButton tap animation
    func displayButtons(_ show: Bool) {
        animate(show: show, duration: 0.05)
    }
    
    func changeView(_ show: Bool) {
        tableView.isUserInteractionEnabled = !show
        tableView.layer.opacity = show ? 0.7 : 1
        controlView.isHidden = !show
    }
    
    func animate(show: Bool, duration: TimeInterval) {
        if show { self.changeView(show) }
        UIView.animate(
            withDuration: duration,
            animations: { self.firstAnimation(show) }) { _ in
                UIView.animate(
                    withDuration: duration,
                    animations: { self.secondAnimation(show) }) { _ in
                        UIView.animate(
                            withDuration: duration,
                            animations: { self.thirdAnimation(show) }) { _ in
                                if !show { self.changeView(show) }
                            }
                    }
            }
    }
    
    func firstAnimation(_ show: Bool) {
        let angle: CGFloat
        
        if show {
            [addTimerButton, addTimerLabel].forEach { $0.alpha = 1 }
            angle = Double.pi / 4
        }
        else {
            [settingsButton, settingsLabel].forEach { $0.alpha = 0 }
            angle = 0
        }
        
        addButton.transform = CGAffineTransform(rotationAngle: angle)
    }
    
    func secondAnimation(_ show: Bool) {
        [addSectionButton, addSectionLabel]
            .forEach { $0.alpha = show ? 1 : 0 }
    }
    
    func thirdAnimation(_ show: Bool) {
        show
        ? [settingsButton, settingsLabel].forEach { $0.alpha = 1 }
        : [addTimerButton, addTimerLabel].forEach { $0.alpha = 0 }
    }
}
