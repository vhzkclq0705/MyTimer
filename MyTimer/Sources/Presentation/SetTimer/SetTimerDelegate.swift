//
//  SetTimerDelegate.swift
//  MyTimer
//
//  Created by 권오준 on 2022/07/11.
//

import Foundation

protocol SetTimerDelegate {
    func updateTimer(section: Int, timer: MyTimer)
}
