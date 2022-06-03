//
//  DetailTimerViewModel.swift
//  MyTimer
//
//  Created by 권오준 on 2022/06/03.
//

import Foundation
import UIKit

class DetailTimerViewModel {
    
    var time: Double!
    var myTimer: MyTimer!
    
    var title: String {
        return myTimer.title
    }
    
    var remainingTime: Double {
        return time
    }
    
    func initTime(){
        time = Double(myTimer.min * 60 + myTimer.sec)
    }
    
    func updateCounter() {
        time -= 0.2
    }
    
    func timeFormatted() -> String {
        let min = time / 60
        let sec = time.truncatingRemainder(dividingBy: 60)
        
        return String(format: "%02d:%02d", Int(min), Int(sec))
    }
    
    func loadTimer(_ myTimer: MyTimer) {
        self.myTimer = myTimer
        initTime()
    }
    
}
