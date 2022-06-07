//
//  AlarmSound.swift
//  MyTimer
//
//  Created by 권오준 on 2022/06/07.
//

import Foundation
import AVFoundation

// Change from Settings
var soundEffect = AVAudioPlayer()
var alarmSound = ""

func playAudio(_ isDetail: Bool) {
    guard let url = Bundle.main.url(forResource: alarmSound, withExtension: "mp3") else { return }
    do {
        soundEffect = try AVAudioPlayer(contentsOf: url)
        let sound = soundEffect
        
        sound.numberOfLoops = isDetail ? -1 : 0
        sound.prepareToPlay()
        sound.play()
    } catch let error {
        print(error.localizedDescription)
    }
}

func stopAudio() {
    soundEffect.stop()
}

func loadAlarmSound() {
    guard let sound = UserDefaults.standard.string(forKey: "alarmSound") else {
        alarmSound = "chicken"
        return
    }
    
    alarmSound = sound
    print("AlarmSound : ", alarmSound)
}
