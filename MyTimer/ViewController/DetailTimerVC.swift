//
//  DetailTimerVC.swift
//  MyTimer
//
//  Created by 권오준 on 2022/06/02.
//

import UIKit
import SnapKit
import AVFoundation

// ViewController for timer
class DetailTimerVC: UIViewController {
    
    // MARK: - Property
    var sectionTitle: String!
    var myTimer: MyTimer!
    var isInited = true
    var timer = Timer()
    var timerisOn = false
    var timeInBackground: Date?
    let viewModel = DetailTimerViewModel()
    let detailTimerView = DetailTimerView()
    
    // MARK: - Life cycle
    override func loadView() {
        view = detailTimerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadTimer(sectionTitle: sectionTitle, myTimer: myTimer)
        setViewController()
        timerNotification()
    }
}

// MARK: - Setup
extension DetailTimerVC {
    func setViewController() {
        detailTimerView.sectionLabel.text = viewModel.section
        detailTimerView.timerLabel.text = viewModel.title
        detailTimerView.circleProgrssBar.createCircularPath()
        remainingTimeText()
        
        detailTimerView.resetButton.addTarget(
            self,
            action: #selector(resetButtonTapped(_:)),
            for: .touchUpInside)
        detailTimerView.startButton.addTarget(
            self,
            action: #selector(startButtonTapped(_:)),
            for: .touchUpInside)
        detailTimerView.backButton.addTarget(
            self,
            action: #selector(cancleButtonTapped(_:)),
            for: .touchUpInside)
        detailTimerView.settingButton.addTarget(
            self,
            action: #selector(didTapSettingsButton(_:)),
            for: .touchUpInside)
        detailTimerView.deleteButton.addTarget(
            self,
            action: #selector(didTapDeleteButton(_:)),
            for: .touchUpInside)
        detailTimerView.recognizeTapGesture.addTarget(
            self,
            action: #selector(recognizeTapped(_:)))
    }
    
    // MARK: - Timer actions
    func remainingTimeText() {
        detailTimerView.remainingMinTime.text = viewModel.min
        detailTimerView.remainingSecTime.text = viewModel.sec
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(updateCounter),
            userInfo: nil,
            repeats: true)
        
        timer.fire()
        timerisOn = true
        print("start")
    }
    
    func stopTimer() {
        timer.invalidate()
        timerisOn = false
        print("stop")
    }
    
    func resetTimer() {
        stopTimer()
        
        detailTimerView.startButton.isSelected = false
        isInited = true
        
        detailTimerView.circleProgrssBar.reset()
        viewModel.initTime()
        remainingTimeText()
    }
    
    func timerIsFinished() {
        detailTimerView.alertView.isHidden = false
        stopTimer()
        playAudio(true)
        tremorsAnimation()
    }
    
    func tremorsAnimation() {
        let angle = Double.pi / 24
        UIView.animate(
            withDuration: 0.01,
            delay: 0,
            options: [.repeat, .autoreverse],
            animations: {
                self.detailTimerView.colon.transform = CGAffineTransform(rotationAngle: angle)
                self.detailTimerView.remainingMinTime.transform = CGAffineTransform(
                    rotationAngle: angle)
                self.detailTimerView.remainingSecTime.transform = CGAffineTransform(
                    rotationAngle: angle)
            })
    }
    
    @objc func updateCounter() {
        viewModel.updateCounter()
        if viewModel.remainingTime > 0 {
            remainingTimeText()
        } else {
            timerIsFinished()
        }
    }
    
    // MARK: - Push notification
    func timerNotification() {
        let notificationCenter = NotificationCenter.default
        // Notification when moving to background state.
        notificationCenter.addObserver(self, selector: #selector(movedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        // Notification when moving to foreground state.
        notificationCenter.addObserver(self, selector: #selector(movedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    func pushNotification() {
        let notiContent = UNMutableNotificationContent()
        notiContent.title = viewModel.title
        notiContent.body = "시간이 되었습니다!!"
        notiContent.sound = UNNotificationSound(
            named: UNNotificationSoundName(rawValue: "\(alarmSound).mp3"))
        
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: viewModel.remainingTime,
            repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "timerDone",
            content: notiContent,
            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    @objc func movedToBackground() {
        if timerisOn {
            stopTimer()
            timeInBackground = Date()
            pushNotification()
        }
    }
    
    @objc func movedToForeground() {
        guard let time = timeInBackground else { return }
        let interval = Date().timeIntervalSince(time)
        if viewModel.remainingTime < interval {
            viewModel.finish()
            remainingTimeText()
            timerIsFinished()
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.viewModel.timeIntervalInBackground(interval)
                self?.startTimer()
            }
        }
    }
    
    // MARK: - Actions
    @objc func recognizeTapped(_ sender: Any) {
        detailTimerView.alertView.isHidden = true
        resetTimer()
        stopAudio()
        
        [
            detailTimerView.colon,
            detailTimerView.remainingMinTime,
            detailTimerView.remainingSecTime,
        ]
            .forEach {
                $0.layer.removeAllAnimations()
                $0.transform = CGAffineTransform(rotationAngle: 0)}
    }
    
    @objc func resetButtonTapped(_ sender: Any) {
        resetTimer()
    }
    
    @objc func startButtonTapped(_ sender: UIButton) {
        detailTimerView.startButton.isSelected = !detailTimerView.startButton.isSelected
        
        if detailTimerView.startButton.isSelected {
            startTimer()
            if isInited {
                detailTimerView.circleProgrssBar.progressAnimation(viewModel.remainingTime)
                isInited = false
            }
            detailTimerView.circleProgrssBar.resumeAnimation()
        } else {
            stopTimer()
            detailTimerView.circleProgrssBar.pauseLayer()
        }
    }
    
    @objc func cancleButtonTapped(_ sender: UIButton) {
        timer.invalidate()
        notifyReloadAndDismiss()
    }
    
    @objc func didTapSettingsButton(_ sender: UIButton) {
        let setTimerVC = SetTimerVC()
        setTimerVC.delegate = self
        setTimerVC.sectionTitle = sectionTitle
        setTimerVC.timer = myTimer
        presentCustom(setTimerVC)
    }
    
    @objc func didTapDeleteButton(_ sender: UIButton) {
        viewModel.deleteTimer(
            sectionTitle: sectionTitle,
            timer: myTimer)
    }
}

// MARK: - Delegate
extension DetailTimerVC: SetTimerDelegate {
    func updateTimer(section: Int, timer: MyTimer) {
        let sectionTitle = TimerManager.shared.sections[section].title
        viewModel.loadTimer(sectionTitle: sectionTitle, myTimer: timer)
        setViewController()
    }
}
