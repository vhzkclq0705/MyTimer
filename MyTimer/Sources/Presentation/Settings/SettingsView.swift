//
//  SettingsView.swift
//  MyTimer
//
//  Created by 권오준 on 2022/07/11.
//

import UIKit

import SnapKit

class SettingsView: UIView {
    
    // MARK: - UI
    let backgroundView: UIView = {
        let view = UIView()
        view.setBackgroundView()
        
        return view
    }()
    
    let goalLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: "각오 한 마디",
            font: .bold,
            size: 15,
            color: .black)
        
        return label
    }()
    
    lazy var goalTextField: UITextView = {
        let textView = UITextView()
        textView.setTextView("자신의 각오 한 마디를 입력해주세요")
        textView.textContainerInset = UIEdgeInsets(
            top: 15,
            left: 12,
            bottom: 15,
            right: 12)
        
        return textView
    }()
    
    let alarmLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: "알람 소리 설정",
            font: .bold,
            size: 15,
            color: .black)
        
        return label
    }()
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        
        return pickerView
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(named: "playCircleLarge"),
            for: .normal)
        
        return button
    }()
    
    lazy var okButton: UIButton = {
        let button = UIButton()
        button.setSubViewOKButton()
        
        return button
    }()
    
    lazy var cancleButton: UIButton = {
        let button = UIButton()
        button.setSubViewCancleButton()
        
        return button
    }()
    
    let topBorder: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.CustomColor(.gray1)
        
        return view
    }()
    
    let bottomBorder: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.CustomColor(.gray1)
        
        return view
    }()
    
    let alaramView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    let subView: UIView = {
        let view = UIView()
        view.setupSubView()
        
        return view
    }()
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        [
            pickerView,
            topBorder,
            bottomBorder,
            playButton,
        ]
            .forEach { alaramView.addSubview($0) }
        
        [
            goalLabel,
            goalTextField,
            alarmLabel,
            alaramView,
            okButton,
            cancleButton
        ]
            .forEach { subView.addSubview($0) }
        
        [backgroundView, subView]
            .forEach { addSubview($0) }
    }
    
    func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        subView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.right.equalToSuperview().inset(17)
            $0.height.equalTo(434)
        }
        
        goalLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(37)
            $0.left.right.equalToSuperview().inset(18)
        }
        
        goalTextField.snp.makeConstraints {
            $0.top.equalTo(goalLabel.snp.bottom).offset(7)
            $0.left.right.equalTo(goalLabel)
            $0.height.equalTo(81)
        }
        
        alarmLabel.snp.makeConstraints {
            $0.top.equalTo(goalTextField.snp.bottom).offset(17)
            $0.left.right.equalTo(goalLabel)
        }
        
        alaramView.snp.makeConstraints {
            $0.top.equalTo(alarmLabel.snp.bottom).offset(17)
            $0.bottom.equalTo(cancleButton.snp.top).offset(-35)
            $0.left.right.equalTo(goalLabel)
        }
        
        pickerView.snp.makeConstraints {
            $0.top.bottom.left.equalToSuperview()
            $0.right.equalTo(playButton.snp.left).offset(-15)
        }
        
        topBorder.snp.makeConstraints {
            $0.centerY.equalTo(pickerView).offset(-17.5)
            $0.left.right.equalTo(pickerView)
            $0.height.equalTo(1)
        }
        
        bottomBorder.snp.makeConstraints {
            $0.centerY.equalTo(pickerView).offset(17.5)
            $0.left.right.equalTo(pickerView)
            $0.height.equalTo(1)
        }
        
        playButton.snp.makeConstraints {
            $0.centerY.equalTo(pickerView)
            $0.right.equalToSuperview()
            $0.width.height.equalTo(37)
        }
        
        okButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.equalTo(goalTextField.snp.centerX)
            $0.right.equalToSuperview()
            $0.height.equalTo(59)
        }
        
        cancleButton.snp.makeConstraints {
            $0.top.equalTo(okButton)
            $0.left.equalToSuperview()
            $0.right.equalTo(goalTextField.snp.centerX)
            $0.height.equalTo(59)
        }
    }
}
