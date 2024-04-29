//
//  AddORSetTimerView.swift
//  MyTimer
//
//  Created by 권오준 on 2022/07/06.
//

import UIKit
import SnapKit
import Then

final class AddORSetTimerView: BaseView {
    
    // MARK: UI
    
    lazy var sectionLabel = UILabel().then {
        $0.setLabelStyle(
            text: "섹션 선택",
            font: .bold,
            size: 15,
            color: .black)
    }

    lazy var sectionTextField = UITextView().then {
        $0.setTextView("섹션을 선택해주세요")
        $0.isUserInteractionEnabled = false
    }
    
    lazy var alertSectionLabel = UILabel().then {
        $0.setLabelStyle(
            text: "섹션을 선택해주세요",
            font: .medium,
            size: 12,
            color: .CustomColor(.red))
        $0.alpha = 0
    }
    
    lazy var sectionButton = UIButton().then {
        $0.setImage(
            UIImage(named: "arrowDown")?.withTintColor(.black),
            for: .normal)
        $0.setImage(
            UIImage(named: "arrowUp")?.withTintColor(.black),
            for: .selected)
    }
    
    lazy var sectionView = UIView()
    
    lazy var timerLabel = UILabel().then {
        $0.setLabelStyle(
            text: "타이머 이름",
            font: .bold,
            size: 15,
            color: .black)
    }
    
    lazy var timerTextField = UITextView().then {
        $0.setTextView("타이머 이름을 입력해주세요")
    }
    
    lazy var alertTimerLabel = UILabel().then {
        $0.setLabelStyle(
            text: "타이머 이름을 입력해주세요",
            font: .medium,
            size: 12,
            color: UIColor.CustomColor(.red))
        $0.alpha = 0
    }
    
    lazy var timerSettingLabel = UILabel().then {
        $0.setLabelStyle(
            text: "타이머 설정",
            font: .bold,
            size: 15,
            color: .black)
    }
    
    lazy var pickerView = UIPickerView()
    
    lazy var okButton = UIButton().then {
        $0.setConfirmButtons(.Ok)
    }
    
    lazy var cancleButton = UIButton().then {
        $0.setConfirmButtons(.Cancel)
    }
    
    lazy var subView = UIView().then {
        $0.setupSubView()
    }
    
    // MARK: Properties
    
    // MARK: Init
    
    init(frame: CGRect, feature: SubViewFeature) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure
    
    override func configureUI() {
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
        
        addSubview(subView)
    }
    
    override func configureLayout() {
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
