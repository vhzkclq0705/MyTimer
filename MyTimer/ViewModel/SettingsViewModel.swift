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
        "Beep1",
        "Beep2",
        "Beep3",
        "Beep4",
        "Beep5",
        "Beep6",
        "Beep7",
        "Beep8",
        "School Bell",
        "Siren",
        "Telephon Ring",
        "chicken",
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
