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
    func numOfRows(_ component: Int) -> Int {
        return sounds.count
    }
    
    func componentsLabel(_ row: Int) -> UIView {
        let label = UILabel()
        label.setLabelStyle(
            text: "\(sounds[row])",
            font: .bold,
            size: 23,
            color: .black)
        label.textAlignment = .center
        
        return label
    }
    
    func didSelectAlarm(_ row: Int) {
        alarmSound = sounds[row]
    }
    
    var numOfSounds: Int {
        return sounds.count
    }
    
    func save(_ text: String) {
        UserDefaults.standard.set(alarmSound, forKey: "alarmSound")
        UserDefaults.standard.set(text, forKey: "goal")
    }
}
