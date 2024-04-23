//
//  DetailTimerView.swift
//  MyTimer
//
//  Created by 권오준 on 2022/07/11.
//

import UIKit

class DetailTimerView: UIView {
    
    // MARK: - UI
    let circleProgrssBar = CircleProgressBar()
    
    let sectionLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: "",
            font: .bold,
            size: 20,
            color: .black)
        label.textAlignment = .center
        
        return label
    }()
    
    let colon: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: " : ",
            font: .bold,
            size: 60,
            color: .black)
        
        return label
    }()
    
    let remainingMinTime: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: "",
            font: .bold,
            size: 60,
            color: .black)
        
        return label
    }()
    
    let remainingSecTime: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: "",
            font: .bold,
            size: 60,
            color: .black)
        
        return label
    }()
    
    let timerLabel: UILabel = {
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
        
        return button
    }()
    
    lazy var startButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "play"), for: .normal)
        button.setImage(UIImage(named: "pause"), for: .selected)
        
        return button
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrowBack"), for: .normal)
        
        return button
    }()
    
    let alertView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        view.isHidden = true
        
        return view
    }()
    
    let alertLabel: UILabel = {
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
        
        return button
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "delete"), for: .normal)
        
        return button
    }()
    
    let recognizeTapGesture = UITapGestureRecognizer()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setLayout()
    }
    
    // MARK: - Setup
    func addViews() {
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
            .forEach { addSubview($0) }
    }
    
    func setLayout() {
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
            $0.top.equalTo(safeAreaLayoutGuide).offset(15)
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
