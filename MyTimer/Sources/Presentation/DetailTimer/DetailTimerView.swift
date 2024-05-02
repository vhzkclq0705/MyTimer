//
//  DetailTimerView.swift
//  MyTimer
//
//  Created by 권오준 on 2022/07/11.
//

import UIKit
import SnapKit
import Then

final class DetailTimerView: BaseView {
    
    // MARK: UI
    
    lazy var circleProgrssBar = CircleProgressBar()
    
    lazy var sectionLabel = UILabel().then {
        $0.setLabelStyle(text: "", font: .bold, size: 20, color: .black)
        $0.textAlignment = .center
    }
    
    lazy var remainingTimeLabel = UILabel().then {
        $0.setLabelStyle(text: "", font: .bold, size: 60, color: .black)
    }
    
    let timerLabel = UILabel().then {
        $0.setLabelStyle(text: "", font: .bold, size: 25, color: .black)
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    lazy var resetButton = UIButton().then {
        $0.setImage(UIImage(named: "reset"), for: .normal)
    }
    
    lazy var timerStateButton = UIButton().then {
        $0.setImage(UIImage(named: "play"), for: .normal)
        $0.setImage(UIImage(named: "pause"), for: .selected)
    }
    
    lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "arrowBack"), for: .normal)
    }
    
    lazy var bellButton = UIButton().then {
        $0.setAttributedTitle(
            NSAttributedString(
                string: "화면을 터치하세요!!",
                attributes: [ .font: UIFont(name: Font.bold.rawValue, size: 40)!,
                              .foregroundColor: UIColor.white,
                ]),
            for: .normal)
        $0.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        $0.isHidden = true
    }
    
    lazy var settingButton = UIButton().then {
        $0.setImage(UIImage(named: "settingFill"), for: .normal)
    }
    
    lazy var deleteButton = UIButton().then {
        $0.setImage(UIImage(named: "delete"), for: .normal)
    }
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure
    
    override func configureUI() {
        [
            sectionLabel,
            timerLabel,
            remainingTimeLabel,
            resetButton,
            timerStateButton,
            backButton,
            circleProgrssBar,
            bellButton,
            settingButton,
            deleteButton
        ]
            .forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        circleProgrssBar.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-100)
            $0.centerX.equalToSuperview()
        }
        
        bellButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        sectionLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(15)
            $0.centerX.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalTo(sectionLabel)
            $0.left.equalToSuperview().offset(16)
        }
        
        remainingTimeLabel.snp.makeConstraints {
            $0.center.equalTo(circleProgrssBar)
        }
        
        timerLabel.snp.makeConstraints {
            $0.top.equalTo(remainingTimeLabel.snp.bottom).offset(165)
            $0.centerX.equalToSuperview()
        }
        
        resetButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-148)
            $0.left.equalToSuperview().offset(35)
        }
        
        timerStateButton.snp.makeConstraints {
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
    
    // MARK: Update UI
    
    func updateTitles(title: (String, String)) {
        sectionLabel.text = title.0
        timerLabel.text = title.1
    }
    
    func updateRemainingTime(time: String) {
        remainingTimeLabel.text = time
    }
    
    func updateTimerState() {
        timerStateButton.isSelected.toggle()
    }
    
    func updateNotificationView(show: Bool) {
        bellButton.isHidden = !show
        shakeViews(show: show)
    }
    
    // MARK: Helper Methods
    
    private func shakeViews(show: Bool) {
        let angle = Double.pi / 24
        
        UIView.animate(withDuration: 0.01, delay: 0, options: [.repeat, .autoreverse], animations: { [weak self] in
            guard let self else { return }
            [
                self.circleProgrssBar,
                self.remainingTimeLabel,
                self.backButton,
                self.timerStateButton,
                self.resetButton,
                self.settingButton,
                self.deleteButton
            ]
                .forEach {
                    show
                    ? $0.transform = CGAffineTransform(rotationAngle: angle)
                    : $0.layer.removeAllAnimations()
                }
                
        })
    }
    
}
