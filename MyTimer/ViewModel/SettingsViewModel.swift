//
//  SettingsViewModel.swift
//  MyTimer
//
//  Created by 권오준 on 2022/06/08.
//

import Foundation
import UIKit

// ViewModel for SetttingsVC
class SettingsViewModel {
    
    // MARK: - Property
    let sounds = [
        "알람1",
        "알람2",
        "알람3",
        "알람4",
        "알람5",
        "알람6",
        "알람7",
        "알람8",
        "학교 종소리",
        "사이렌",
        "전화 벨소리",
        "닭소리",
    ]
    
    // MARK: - UI
    var numOfSounds: Int {
        return sounds.count
    }
    
    // MARK: - Funcs for set alarm sound
    func changeAlarmSound(_ index: Int) {
        alarmSound = sounds[index]
        save()
    }
    
    func save() {
        UserDefaults.standard.set(alarmSound, forKey: "alarmSound")
    }
}
