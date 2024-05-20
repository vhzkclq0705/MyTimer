//
//  DetailTimerViewController.swift
//  MyTimer
//
//  Created by 권오준 on 2022/06/02.
//

import UIKit
import RxSwift
import RxCocoa

/// ViewController for timers
final class DetailTimerViewController: BaseViewController {
    
    // MARK: Properties
    
    private let viewModel: DetailTimerViewModel
    private let detailTimerView = DetailTimerView()
    private let disposeBag = DisposeBag()
    
//    var sectionTitle: String!
//    var myTimer: MyTimer!
//    var isInited = true
//    var timer = Timer()
//    var timerisOn = false
//    var timeInBackground: Date?
    
    // MARK: Init
    
    init(viewModel: DetailTimerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life cycle
    
    override func loadView() {
        view = detailTimerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        detailTimerView.setupProgressingLayers()
    }
    
    // MARK: Configure
    
    override func configureViewController() {
        setupBindings()
    }
    
    private func setupBindings() {
        let input = DetailTimerViewModel.Input(
            resetButtonTapEvent: detailTimerView.resetButton.rx.tap.asObservable(),
            timerStateButtonTapEvent: detailTimerView.timerStateButton.rx.tap.asObservable(),
            backButtonTapEvent: detailTimerView.backButton.rx.tap.asObservable(),
            settingsButtonTapEvent: detailTimerView.settingButton.rx.tap.asObservable(),
            deleteButtonTapEvent: detailTimerView.deleteButton.rx.tap.asObservable(),
            bellButtonTapEvent: detailTimerView.bellButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.titles
            .drive(with: self, onNext: { owner, title in
                owner.detailTimerView.updateTitles(title: title)
            })
            .disposed(by: disposeBag)
        
        output.initTime
            .drive(with: self, onNext: { owner, time in
                owner.detailTimerView.setupProgressingAnimation(duration: time)
            })
            .disposed(by: disposeBag)
        
        output.remainingTimeText
            .drive(with: self, onNext: { owner, time in
                owner.detailTimerView.updateRemainingTime(time: time)
            })
            .disposed(by: disposeBag)
        
        output.sendNotification
            .emit(with: self, onNext: { owner, _ in
                
            })
            .disposed(by: disposeBag)
        
        output.removeAlarm
            .emit(with: self, onNext: { owner, _ in
                
            })
            .disposed(by: disposeBag)
        
        output.resetTimer
            .emit(with: self, onNext: { owner, _ in
                owner.detailTimerView.changeProgressingState(state: .reset)
            })
            .disposed(by: disposeBag)
        
        output.changeTimerState
            .emit(with: self, onNext: { owner, _ in
                owner.detailTimerView.changeProgressingState(state: .start)
            })
            .disposed(by: disposeBag)
        
        output.presentSettingsViewController
            .emit(with: self, onNext: { owner, _ in
                
            })
            .disposed(by: disposeBag)
        
        output.deleteTimer
            .emit(with: self, onNext: { owner, _ in
                
            })
            .disposed(by: disposeBag)
        
        output.dismissViewController
            .emit(with: self, onNext: { owner, _ in
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    //    func setViewController() {
    //        detailTimerView.sectionLabel.text = viewModel.section
    //        detailTimerView.timerLabel.text = viewModel.title
    //        detailTimerView.circleProgrssBar.createCircularPath()
    //        remainingTimeText()
    //
    //        detailTimerView.resetButton.addTarget(
    //            self,
    //            action: #selector(resetButtonTapped(_:)),
    //            for: .touchUpInside)
    //        detailTimerView.startButton.addTarget(
    //            self,
    //            action: #selector(startButtonTapped(_:)),
    //            for: .touchUpInside)
    //        detailTimerView.backButton.addTarget(
    //            self,
    //            action: #selector(didTapCancleButton(_:)),
    //            for: .touchUpInside)
    //        detailTimerView.settingButton.addTarget(
    //            self,
    //            action: #selector(didTapSettingsButton(_:)),
    //            for: .touchUpInside)
    //        detailTimerView.deleteButton.addTarget(
    //            self,
    //            action: #selector(didTapDeleteButton(_:)),
    //            for: .touchUpInside)
    //        detailTimerView.recognizeTapGesture.addTarget(
    //            self,
    //            action: #selector(recognizeTapped(_:)))
    //    }
    //
    //    // MARK: - Timer actions
    //    func remainingTimeText() {
    //        detailTimerView.remainingMinTime.text = viewModel.min
    //        detailTimerView.remainingSecTime.text = viewModel.sec
    //    }
    
    //    func startTimer() {
    //        timer = Timer.scheduledTimer(
    //            timeInterval: 0.1,
    //            target: self,
    //            selector: #selector(updateCounter),
    //            userInfo: nil,
    //            repeats: true)
    //
    //        timer.fire()
    //        timerisOn = true
    //        print("start")
    //    }
    //
    //    func stopTimer() {
    //        timer.invalidate()
    //        timerisOn = false
    //        print("stop")
    //    }
    //
    //    func play() {
    //        startTimer()
    //        if isInited {
    //            detailTimerView.circleProgrssBar.progressAnimation(viewModel.remainingTime)
    //            isInited = false
    //        }
    //        detailTimerView.circleProgrssBar.resumeAnimation()
    //    }
    //
    //    func pause() {
    //        stopTimer()
    //        detailTimerView.circleProgrssBar.pauseLayer()
    //    }
    //
    //    func resetTimer() {
    //        stopTimer()
    //
    //        detailTimerView.startButton.isSelected = false
    //        isInited = true
    //
    //        detailTimerView.circleProgrssBar.reset()
    //        viewModel.initTime()
    //        remainingTimeText()
    //    }
    //
    //    func timerIsFinished() {
    //        detailTimerView.alertView.isHidden = false
    //        stopTimer()
    //        playAudio(true)
    //        tremorsAnimation()
    //    }
    //
    //    func tremorsAnimation() {
    //        let angle = Double.pi / 24
    //        UIView.animate(
    //            withDuration: 0.01,
    //            delay: 0,
    //            options: [.repeat, .autoreverse],
    //            animations: {
    //                self.detailTimerView.colon.transform = CGAffineTransform(rotationAngle: angle)
    //                self.detailTimerView.remainingMinTime.transform = CGAffineTransform(
    //                    rotationAngle: angle)
    //                self.detailTimerView.remainingSecTime.transform = CGAffineTransform(
    //                    rotationAngle: angle)
    //            })
    //    }
    //
    //    @objc func updateCounter() {
    //        viewModel.updateCounter()
    //        if viewModel.remainingTime > 0 {
    //            remainingTimeText()
    //        } else {
    //            timerIsFinished()
    //        }
    //    }
    
    //    // MARK: - Push notification
    //    func timerNotification() {
    //        let notificationCenter = NotificationCenter.default
    //        // Notification when moving to background state.
    //        notificationCenter.addObserver(self, selector: #selector(movedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
    //        // Notification when moving to foreground state.
    //        notificationCenter.addObserver(self, selector: #selector(movedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    //    }
    //
    //    func pushNotification() {
    //        let notiContent = UNMutableNotificationContent()
    //        notiContent.title = viewModel.title
    //        notiContent.body = "시간이 되었습니다!!"
    //        notiContent.sound = UNNotificationSound(
    //            named: UNNotificationSoundName(rawValue: "\(alarmSound).mp3"))
    //
    //        let trigger = UNTimeIntervalNotificationTrigger(
    //            timeInterval: viewModel.remainingTime,
    //            repeats: false)
    //
    //        let request = UNNotificationRequest(
    //            identifier: "timerDone",
    //            content: notiContent,
    //            trigger: trigger)
    //
    //        UNUserNotificationCenter.current().add(request) { error in
    //            if let error = error {
    //                print(error)
    //            }
    //        }
    //    }
    //
    //    @objc func movedToBackground() {
    //        if timerisOn {
    //            stopTimer()
    //            timeInBackground = Date()
    //            pushNotification()
    //        }
    //    }
    //
    //    @objc func movedToForeground() {
    //        guard let time = timeInBackground else { return }
    //        let interval = Date().timeIntervalSince(time)
    //        if viewModel.remainingTime < interval {
    //            viewModel.finish()
    //            remainingTimeText()
    //            timerIsFinished()
    //        } else {
    //            DispatchQueue.main.async { [weak self] in
    //                self?.viewModel.timeIntervalInBackground(interval)
    //                self?.startTimer()
    //            }
    //        }
    //    }
    //
    //    // MARK: - Actions
    //    @objc func recognizeTapped(_ sender: Any) {
    //        detailTimerView.alertView.isHidden = true
    //        resetTimer()
    //        stopAudio()
    //
    //        [
    //            detailTimerView.colon,
    //            detailTimerView.remainingMinTime,
    //            detailTimerView.remainingSecTime,
    //        ]
    //            .forEach {
    //                $0.layer.removeAllAnimations()
    //                $0.transform = CGAffineTransform(rotationAngle: 0)}
    //    }
    //
    //    @objc func resetButtonTapped(_ sender: Any) {
    //        resetTimer()
    //    }
    //
    //    @objc func startButtonTapped(_ sender: UIButton) {
    //        detailTimerView.startButton.isSelected = !detailTimerView.startButton.isSelected
    //
    //        detailTimerView.startButton.isSelected ? play() : pause()
    //    }
    //
    //    @objc override func didTapCancleButton(_ sender: UIButton) {
    //        timer.invalidate()
    //        notifyReloadAndDismiss()
    //    }
    //
    //    @objc func didTapSettingsButton(_ sender: UIButton) {
    //        detailTimerView.startButton.isSelected = false
    //        pause()
    //
    //        let setTimerVC = SetTimerVC()
    //        setTimerVC.delegate = self
    //        setTimerVC.sectionTitle = sectionTitle
    //        setTimerVC.timer = myTimer
    //        presentCustom(setTimerVC)
    //    }
    //
    //    @objc func didTapDeleteButton(_ sender: UIButton) {
    //        detailTimerView.startButton.isSelected = false
    //        pause()
    //
    //        let vc = DeleteVC()
    //        vc.type = .timer
    //        vc.sectionTitle = sectionTitle
    //        vc.timer = myTimer
    //
    //        presentCustom(vc)
    //    }
    //}
    //
    //// MARK: - Delegate
    //extension DetailTimerVC: SetTimerDelegate {
    //    func updateTimer(section: Int, timer: MyTimer) {
    //        let sectionTitle = TimerManager.shared.sections[section].title
    //        self.myTimer = timer
    //        viewModel.loadTimer(sectionTitle: sectionTitle, myTimer: timer)
    //        setViewController()
    //        resetTimer()
    //    }
    //}
}
