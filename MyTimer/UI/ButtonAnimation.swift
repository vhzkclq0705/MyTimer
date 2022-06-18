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
        tableView.isUserInteractionEnabled = !show
        tableView.layer.opacity = show ? 0.7 : 1
        controlView.isHidden = !show
        
        let angle: CGFloat = show ? Double.pi / 4 : 0
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: .transitionCrossDissolve,
            animations: {
                self.addButton.transform = CGAffineTransform(rotationAngle: angle)
                if show {
                    self.addTimerButton.alpha = 1
                    self.addTimerLabel.alpha = 1
                } else {
                    self.settingsButton.alpha = 0
                    self.settingsLabel.alpha = 0
                }
            }, completion: { _ in
                UIView.animate(
                    withDuration: 0.1,
                    delay: 0,
                    options: .transitionCrossDissolve,
                    animations: {
                        if show {
                            self.addSectionButton.alpha = 1
                            self.addSectionLabel.alpha = 1
                        } else {
                            self.addTimerButton.alpha = 0
                            self.addTimerLabel.alpha = 0
                        }
                    }, completion: { _ in
                        UIView.animate(
                            withDuration: 0.1,
                            delay: 0,
                            options: .transitionCrossDissolve,
                            animations: {
                                if show {
                                    self.settingsButton.alpha = 1
                                    self.settingsLabel.alpha = 1
                                } else {
                                    self.addSectionButton.alpha = 0
                                    self.addSectionLabel.alpha = 0
                                }
                            })
                    })
            })
    }
}
