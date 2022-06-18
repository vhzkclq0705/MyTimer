//
//  NotiPermission.swift
//  MyTimer
//
//  Created by 권오준 on 2022/06/18.
//

import Foundation
import UIKit

// Request for notification authority when the application is started first
func requestAuthNoti() {
    UNUserNotificationCenter.current().requestAuthorization(
        options: [.alert, .sound]) { success, error in
            if let error = error {
                print(error)
            }
        }
}
