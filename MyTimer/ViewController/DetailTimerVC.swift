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
    
    // MARK: - Create UI items
    lazy var circleProgrssBar = CircleProgressBar()
    
    lazy var sectionLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: "",
            font: .bold,
            size: 20,
            color: .black)
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var colon: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: " : ",
            font: .bold,
            size: 60,
            color: .black)
        
        return label
    }()
    
    lazy var remainingMinTime: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: "",
            font: .bold,
            size: 60,
            color: .black)
        
        return label
    }()
    
    lazy var remainingSecTime: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: "",
            font: .bold,
            size: 60,
            color: .black)
        
        return label
    }()
    
    lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: "",
            font: .bold,
            size: 25,
            color: .black)
        label.textAlignment = .center
        label.numberOfLines = 2
        
        return label
    }()
    
    lazy var resetButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(named: "reset"),
            for: .normal)
        button.addTarget(
            self,
            action: #selector(resetButtonTapped(_:)),
            for: .touchUpInside)
        
        return button
    }()
    
    lazy var startButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "play"), for: .normal)
        button.setImage(UIImage(named: "pause"), for: .selected)
        button.addTarget(
            self,
            action: #selector(startButtonTapped(_:)),
            for: .touchUpInside)
        
        return button
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrowBack"), for: .normal)
        button.addTarget(
            self,
            action: #selector(cancleButtonTapped(_:)),
            for: .touchUpInside)
        
        return button
    }()
    
    lazy var alertView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        view.isHidden = true
        
        return view
    }()
    
    lazy var alertLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: "화면을 터치하세요!!",
            font: .bold,
            size: 40,
            color: .white)
        
        return label
    }()
    
    lazy var settingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "settingFill"), for: .normal)
        button.addTarget(
            self,
            action: #selector(didTapSettingsButton(_:)),
            for: .touchUpInside)
        
        return button
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "delete"), for: .normal)
        button.addTarget(
            self,
            action: #selector(didTapDeleteButton(_:)),
            for: .touchUpInside)
        
        return button
    }()
    
    lazy var recognizeTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(recognizeTapped(_:)))
        
        return gesture
    }()
    
    // MARK: - Property
    var sectionTitle: String!
    var myTimer: MyTimer!
    var isInited = true
    var timer = Timer()
    var timerisOn = false
    var timeInBackground: Date?
    let viewModel = DetailTimerViewModel()
    
    // MARK: - Funcs for life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadTimer(myTimer)
        setupUI()
        timerNotification()
    }
}

// MARK: - Setup UI
extension DetailTimerVC {
    func setupUI() {
        view.backgroundColor = .white
        sectionLabel.text = sectionTitle
        timerLabel.text = viewModel.title
        remainingTimeText()
        circleProgrssBar.createCircularPath()
        
        alertView.addGestureRecognizer(recognizeTapGesture)
        alertView.addSubview(alertLabel)
        
        [
            sectionLabel,
            timerLabel,
            remainingMinTime,
            remainingSecTime,
            colon,
            resetButton,
            startButton,
            backButton,
            circleProgrssBar,
            alertView,
            settingButton,
            deleteButton,
        ]
            .forEach { view.addSubview($0) }
        
        circleProgrssBar.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-100)
            $0.centerX.equalToSuperview()
        }
        
        alertView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        alertLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-250)
        }
        
        sectionLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(15)
            $0.centerX.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalTo(sectionLabel)
            $0.left.equalToSuperview().offset(16)
        }
        
        colon.snp.makeConstraints {
            $0.center.equalTo(circleProgrssBar)
        }
        
        remainingMinTime.snp.makeConstraints {
            $0.centerY.equalTo(colon)
            $0.right.equalTo(colon.snp.left)
        }
        
        remainingSecTime.snp.makeConstraints {
            $0.centerY.equalTo(colon)
            $0.left.equalTo(colon.snp.right)
        }
        
        timerLabel.snp.makeConstraints {
            $0.top.equalTo(colon.snp.bottom).offset(165)
            $0.centerX.equalToSuperview()
        }
        
        resetButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-148)
            $0.left.equalToSuperview().offset(35)
        }
        
        startButton.snp.makeConstraints {
            $0.centerY.equalTo(resetButton)
            $0.right.equalToSuperview().offset(-35)
        }
        
        settingButton.snp.makeConstraints{
            $0.centerY.equalTo(sectionLabel)
            $0.right.equalToSuperview().offset(-19)
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.equalTo(settingButton.snp.bottom).offset(15)
            $0.right.equalTo(settingButton)
        }
    }
}

// MARK: - Timer actions
extension DetailTimerVC {
    func remainingTimeText() {
        remainingMinTime.text = viewModel.min
        remainingSecTime.text = viewModel.sec
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
        
        startButton.isSelected = false
        isInited = true
        
        circleProgrssBar.reset()
        viewModel.initTime()
        remainingTimeText()
    }
    
    func timerIsFinished() {
        alertView.isHidden = false
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
                self.colon.transform = CGAffineTransform(rotationAngle: angle)
                self.remainingMinTime.transform = CGAffineTransform(
                    rotationAngle: angle)
                self.remainingSecTime.transform = CGAffineTransform(
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
}


// MARK: - Push notification
extension DetailTimerVC {
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
}

// MARK: - Detect app state
extension DetailTimerVC {
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
}

// MARK: - Button actions
extension DetailTimerVC {
    @objc func recognizeTapped(_ sender: Any) {
        alertView.isHidden = true
        resetTimer()
        stopAudio()
        
        colon.layer.removeAllAnimations()
        remainingMinTime.layer.removeAllAnimations()
        remainingSecTime.layer.removeAllAnimations()
        
        colon.transform = CGAffineTransform(rotationAngle: 0)
        remainingMinTime.transform = CGAffineTransform(rotationAngle: 0)
        remainingSecTime.transform = CGAffineTransform(rotationAngle: 0)
    }
    
    @objc func resetButtonTapped(_ sender: Any) {
        resetTimer()
    }
    
    @objc func startButtonTapped(_ sender: UIButton) {
        startButton.isSelected = !startButton.isSelected
        
        if startButton.isSelected {
            startTimer()
            if isInited {
                circleProgrssBar.progressAnimation(viewModel.remainingTime)
                isInited = false
            }
            circleProgrssBar.resumeAnimation()
        } else {
            stopTimer()
            circleProgrssBar.pauseLayer()
        }
    }
    
    @objc func cancleButtonTapped(_ sender: UIButton) {
        timer.invalidate()
        notifyReloadAndDismiss()
    }
    
    @objc func didTapSettingsButton(_ sender: UIButton) {
        let setTimerVC = SetTimerVC()
        setTimerVC.sectionTitle = sectionTitle
        setTimerVC.timer = myTimer
        setTimerVC.modalTransitionStyle = .crossDissolve
        setTimerVC.modalPresentationStyle = .overFullScreen
        
        present(setTimerVC, animated: true)
    }
    
    @objc func didTapDeleteButton(_ sender: UIButton) {
        
    }
}
