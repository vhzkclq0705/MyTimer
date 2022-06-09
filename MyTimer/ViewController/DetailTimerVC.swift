//
//  DetailTimerVC.swift
//  MyTimer
//
//  Created by 권오준 on 2022/06/02.
//

import UIKit
import SnapKit
import AVFoundation

class DetailTimerVC: UIViewController {

    lazy var circleProgrssBar = CircleProgressBar()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 30, weight: .bold)
        
        return label
    }()
    
    lazy var colon: UILabel = {
        let label = UILabel()
        label.text = ":"
        label.textColor = .black
        label.font = .systemFont(ofSize: 80, weight: .bold)

        return label
    }()
    
    lazy var remainingMinTime: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 80, weight: .bold)

        return label
    }()
    
    lazy var remainingSecTime: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 80, weight: .bold)
        
        return label
    }()
    
    lazy var subView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        
        return view
    }()
    
    lazy var resetButton: UIButton = {
        let button = UIButton()
        button.timerButtons(false)
        button.setImage(UIImage(systemName: "arrow.counterclockwise"), for: .normal)
        button.addTarget(self, action: #selector(resetButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var startButton: UIButton = {
        let button = UIButton()
        button.timerButtons(false)
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.setImage(UIImage(systemName: "pause.fill"), for: .selected)
        button.addTarget(self, action: #selector(startButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var cancleButton: UIButton = {
        let button = UIButton()
        button.timerButtons(true)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(cancleButtonTapped(_:)), for: .touchUpInside)
        
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
        label.text = "화면을 터치하세요!!"
        //label.font = UIFont(name: "establishRoomNo703", size: 40)
        label.font = .systemFont(ofSize: 40)
        
        return label
    }()
    
    lazy var recognizeTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(recognizeTapped(_:)))
        
        return gesture
    }()
    
    var color: UIColor!
    var myTimer: MyTimer!
    var isInited = true
    var timer = Timer()
    let viewModel = DetailTimerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadTimer(myTimer)
        setupUI()
    }
}

extension DetailTimerVC {
    func setupUI() {
        view.backgroundColor = .clear
        titleLabel.text = viewModel.title
        remainingTimeText()
        circleProgrssBar.createCircularPath(color)
        
        alertView.addGestureRecognizer(recognizeTapGesture)
        alertView.addSubview(alertLabel)
        
        [ titleLabel ,remainingMinTime, remainingSecTime, colon,
          resetButton, startButton, cancleButton ]
            .forEach { subView.addSubview($0) }
        
        [ subView, circleProgrssBar, alertView ]
            .forEach { view.addSubview($0) }
        
        circleProgrssBar.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-30)
        }
        
        alertView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        alertLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(subView.snp.bottom).offset(30)
        }
        
        subView.snp.makeConstraints {
            $0.top.equalTo(circleProgrssBar).offset(-200)
            $0.bottom.equalTo(circleProgrssBar).offset(250)
            $0.left.right.equalTo(circleProgrssBar).inset(-180)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(remainingMinTime.snp.top).offset(-10)
        }

        colon.snp.makeConstraints {
            $0.center.equalTo(circleProgrssBar)
        }
        
        remainingMinTime.snp.makeConstraints {
            $0.centerY.equalTo(circleProgrssBar)
            $0.right.equalTo(colon.snp.left)
        }
        
        remainingSecTime.snp.makeConstraints {
            $0.centerY.equalTo(circleProgrssBar)
            $0.left.equalTo(colon.snp.right)
        }

        resetButton.snp.makeConstraints {
            $0.bottom.left.equalTo(subView).inset(20)
        }
        
        startButton.snp.makeConstraints {
            $0.bottom.right.equalTo(subView).inset(20)
        }
        
        cancleButton.snp.makeConstraints {
            $0.top.right.equalTo(subView).inset(5)
        }
    }
}

extension DetailTimerVC {
    func remainingTimeText() {
        remainingMinTime.text = viewModel.min
        remainingSecTime.text = viewModel.sec
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    func resetTimer() {
        stopTimer()
        
        startButton.isSelected = false
        isInited = true
        
        circleProgrssBar.reset()
        viewModel.initTime()
        remainingTimeText()
    }
    
    func tremorsAnimation() {
        let angle = Double.pi / 24
        UIView.animate(withDuration: 0.01, delay: 0, options: [.repeat, .autoreverse],  animations: { [weak self] in
            self?.colon.transform = CGAffineTransform(rotationAngle: angle)
            self?.remainingMinTime.transform = CGAffineTransform(rotationAngle: angle)
            self?.remainingSecTime.transform = CGAffineTransform(rotationAngle: angle)
        })
    }
    
    @objc func updateCounter() {
        viewModel.updateCounter()
        if viewModel.remainingTime > 0 {
            remainingTimeText()
        } else {
            alertView.isHidden = false
            stopTimer()
            playAudio(true)
            tremorsAnimation()
        }
    }
}

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
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil, userInfo: nil)
        
        dismiss(animated: true)
    }
}
