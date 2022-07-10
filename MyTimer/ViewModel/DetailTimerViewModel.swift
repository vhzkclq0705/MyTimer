//
//  DetailTimerViewModel.swift
//  MyTimer
//
//  Created by 권오준 on 2022/06/03.
//

import Foundation

// ViewModel for DetailTimerVC
class DetailTimerViewModel {
    
    // MARK: - Property
    var time: Double!
    var myTimer: MyTimer!
    var section: String!
    
    // MARK: - UI
    var sectionTitle: String {
        return section
    }
    
    var title: String {
        return myTimer.title
    }
    
    var remainingTime: Double {
        return time
    }
    
    var min: String {
        return String(format: "%02d", Int(time / 60))
    }
    
    var sec: String {
        return String(
            format: "%02d",
            Int(time.truncatingRemainder(dividingBy: 60)))
    }
    
    // MARK: - Timer
    func initTime(){
        time = Double(myTimer.min * 60 + myTimer.sec)
    }
    
    func updateCounter() {
        time -= 0.1
    }
    
    func finish() {
        time = 0
    }
    
    func timeIntervalInBackground(_ interval: Double) {
        time -= (interval * 100).rounded() / 100
        if time < 0 {
            time = 0
        }
    }
    
    // MARK: - Delete timer
    func deleteTimer(sectionTitle: String, timer: MyTimer) {
        TimerManager.shared.deleteTimer(
            sectionTitle: sectionTitle,
            timer: timer)
    }
    
    func loadTimer(sectionTitle: String, myTimer: MyTimer) {
        self.section = sectionTitle
        self.myTimer = myTimer
        initTime()
    }
}
