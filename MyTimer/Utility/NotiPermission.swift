//
//  NotiPermission.swift
//  MyTimer
//
//  Created by 권오준 on 2022/06/18.
//

import Foundation
import UIKit

func requestAuthNoti() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
        if let error = error {
            print(error)
        }
    }
}
