//
//  SetTimerView.swift
//  MyTimer
//
//  Created by 권오준 on 2022/07/06.
//

import UIKit
import SnapKit

class SetTimerView: UIView {
    
    // MARK: - UI
    let backgroundView: UIView = {
        let view = UIView()
//        view.setBackgroundView()
        
        return view
    }()
    
    let sectionLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: "섹션 선택",
            font: .bold,
            size: 15,
            color: .black)
        
        return label
    }()
    
    lazy var sectionTextField: UITextView = {
        let textView = UITextView()
        textView.setTextView("섹션을 선택해주세요")
        textView.isUserInteractionEnabled = false
        
        return textView
    }()
    
    let alertSectionLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: "섹션을 선택해주세요",
            font: .medium,
            size: 12,
            color: UIColor.CustomColor(.red))
        label.alpha = 0
        
        return label
    }()
    
    lazy var sectionButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(named: "arrowDown")?
                .withTintColor(.black),
            for: .normal)
        button.setImage(
            UIImage(named: "arrowUp")?
                .withTintColor(.black),
            for: .selected)
        
        return button
    }()
    
    let sectionView = UIView()
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: "타이머 이름",
            font: .bold,
            size: 15,
            color: .black)
        
        return label
    }()
    
    lazy var timerTextField: UITextView = {
        let textView = UITextView()
        textView.setTextView("타이머 이름을 입력해주세요")
        
        return textView
    }()
    
    let alertTimerLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: "타이머 이름을 입력해주세요",
            font: .medium,
            size: 12,
            color: UIColor.CustomColor(.red))
        label.alpha = 0
        
        return label
    }()
    
    let timerSettingLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: "타이머 설정",
            font: .bold,
            size: 15,
            color: .black)
        
        return label
    }()
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        
        return pickerView
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
            sectionTextField,
            sectionButton,
        ]
            .forEach { sectionView.addSubview($0) }
        
        [
            sectionLabel,
            sectionView,
            alertSectionLabel,
            timerTextField,
            alertTimerLabel,
            timerLabel,
            timerSettingLabel,
            pickerView,
            okButton,
            cancleButton,
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
        
        sectionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(37)
            $0.left.right.equalToSuperview().inset(18)
        }
        
        sectionView.snp.makeConstraints {
            $0.top.equalTo(sectionLabel.snp.bottom).offset(7)
            $0.left.right.equalTo(sectionLabel)
            $0.height.equalTo(51)
        }
        
        sectionTextField.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        sectionButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(11)
        }
        
        alertSectionLabel.snp.makeConstraints {
            $0.top.equalTo(sectionTextField.snp.bottom).offset(3)
            $0.right.equalTo(sectionTextField)
        }
        
        timerLabel.snp.makeConstraints {
            $0.top.equalTo(sectionView.snp.bottom).offset(17)
            $0.left.right.equalTo(sectionLabel)
        }
        
        timerTextField.snp.makeConstraints {
            $0.top.equalTo(timerLabel.snp.bottom).offset(7)
            $0.left.right.equalTo(sectionLabel)
            $0.height.equalTo(51)
        }
        
        alertTimerLabel.snp.makeConstraints {
            $0.top.equalTo(timerTextField.snp.bottom).offset(3)
            $0.right.equalTo(timerTextField)
        }
        
        timerSettingLabel.snp.makeConstraints {
            $0.top.equalTo(timerTextField.snp.bottom).offset(17)
            $0.left.right.equalTo(sectionLabel)
        }
        
        pickerView.snp.makeConstraints {
            $0.top.equalTo(timerSettingLabel.snp.bottom).offset(7)
            $0.left.right.equalToSuperview().inset(60)
            $0.height.equalTo(100)
        }
        
        okButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.equalTo(timerTextField.snp.centerX)
            $0.right.equalToSuperview()
            $0.height.equalTo(59)
        }
        
        cancleButton.snp.makeConstraints {
            $0.top.equalTo(okButton)
            $0.left.equalToSuperview()
            $0.right.equalTo(timerTextField.snp.centerX)
            $0.height.equalTo(59)
        }
    }
}
