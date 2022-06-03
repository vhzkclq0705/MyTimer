//
//  DetailTimerVC.swift
//  MyTimer
//
//  Created by 권오준 on 2022/06/02.
//

import UIKit
import SnapKit

class DetailTimerVC: UIViewController {

    lazy var circleProgrssBar = CircleProgressBar()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "establishRoomNo703", size: 30)
        
        return label
    }()
    
    lazy var remainingTime: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "establishRoomNo703", size: 80)
        
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
        remainingTime.text = viewModel.timeFormatted()
        circleProgrssBar.createCircularPath(color)
        
        [ titleLabel ,remainingTime, resetButton, startButton, cancleButton ]
            .forEach { subView.addSubview($0) }
        
        [ subView, circleProgrssBar ]
            .forEach { view.addSubview($0) }
        
        circleProgrssBar.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-30)
        }
        
        subView.snp.makeConstraints {
            $0.top.equalTo(circleProgrssBar).offset(-200)
            $0.bottom.equalTo(circleProgrssBar).offset(250)
            $0.left.right.equalTo(circleProgrssBar).inset(-180)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(remainingTime.snp.top).offset(-10)
        }

        remainingTime.snp.makeConstraints {
            $0.center.equalTo(circleProgrssBar)
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
        remainingTime.text = viewModel.timeFormatted()
    }
    
    @objc func updateCounter() {
        viewModel.updateCounter()
        if viewModel.remainingTime > 0 {
            remainingTime.text = viewModel.timeFormatted()
        } else {
            resetTimer()
        }
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
