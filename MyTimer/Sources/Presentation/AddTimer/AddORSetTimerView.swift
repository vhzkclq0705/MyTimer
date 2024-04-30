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
    
    lazy var sectionLabel = createMenuTitleLabels("섹션 선택")

    lazy var sectionTextField = UITextView().then {
        $0.setTextView(sectionAlarm)
        $0.isUserInteractionEnabled = false
    }
    
    lazy var alertSectionLabel = createAlertLabels(sectionAlarm)
    
    lazy var arrowImageView = UIImageView().then {
        $0.image = UIImage(named: "arrowDown")
    }
    
    lazy var sectionView = UIView()
    
    lazy var timerLabel = createMenuTitleLabels("타이머 이름")
    
    lazy var timerTextField = UITextView().then {
        $0.setTextView(placeholder)
    }
    
    lazy var alertTimerLabel = createAlertLabels(placeholder)
    
    lazy var timerSettingLabel = createMenuTitleLabels("타이머 설정")
    
    lazy var minPickerView = UIPickerView()
    lazy var minLabel = createTimeUnitLabels("분")
    
    lazy var secPickerView = UIPickerView()
    lazy var secLabel = createTimeUnitLabels("초")
    
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
    
    private let placeholder = "타이머 이름을 입력해주세요."
    private let exceededAlarm = "타이머 이름은 최대 10자 입니다."
    private let sectionAlarm = "섹션을 선택해주세요."
    
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
            arrowImageView,
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
            minPickerView,
            minLabel,
            secPickerView,
            secLabel,
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
        
        arrowImageView.snp.makeConstraints {
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
        
        minPickerView.snp.makeConstraints {
            $0.top.equalTo(timerSettingLabel.snp.bottom).offset(7)
            $0.right.equalTo(minLabel.snp.left).offset(-10)
            $0.width.equalToSuperview().multipliedBy(0.25)
            $0.height.equalTo(100)
        }
        
        minLabel.snp.makeConstraints {
            $0.centerY.equalTo(minPickerView)
            $0.right.equalTo(subView.snp.centerX).offset(-10)
        }
        
        secPickerView.snp.makeConstraints {
            $0.centerY.width.equalTo(minPickerView)
            $0.left.equalTo(subView.snp.centerX).offset(10)
            $0.height.equalTo(100)
        }
        
        secLabel.snp.makeConstraints {
            $0.centerY.equalTo(minPickerView)
            $0.left.equalTo(secPickerView.snp.right).offset(10)
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
    
    // MARK: Update UI
    
    
    // MARK: TextView Management
    
    func validateText(_ length: Int) {
        if timerTextField.text == placeholder { return }
        switch length {
        case 1..<20:
            alertTimerLabel.alpha = 0
            timerTextField.layer.borderColor = UIColor.CustomColor(.gray1).cgColor
            okButton.isUserInteractionEnabled = true
        default:
            if length > 20 {
                timerTextField.deleteBackward()
            }
            
            alertTimerLabel.text = length == 0 ? placeholder : exceededAlarm
            alertTimerLabel.alpha = 1
            timerTextField.layer.borderColor = UIColor.CustomColor(.red).cgColor
            okButton.isUserInteractionEnabled = false
        }
    }
    
    func startEditingTextView() {
        if timerTextField.text == placeholder {
            timerTextField.text = ""
            timerTextField.textColor = .black
        }
    }
    
    func endEditingTextView() {
        if timerTextField.text.isEmpty {
            timerTextField.text = placeholder
            timerTextField.textColor = .CustomColor(.gray1)
            okButton.isUserInteractionEnabled = false
        }
    }
    
    // MARK: Create Common UI Components
    
    private func createMenuTitleLabels(_ text: String) -> UILabel {
        return UILabel().then {
            $0.setLabelStyle(text: text, font: .bold, size: 15, color: .black)
        }
    }
    
    private func createAlertLabels(_ text: String) -> UILabel {
        return UILabel().then {
            $0.setLabelStyle(text: text, font: .medium, size: 12, color: .CustomColor(.red))
            $0.alpha = 0
        }
    }
    
    private func createTimeUnitLabels(_ text: String) -> UILabel {
        return UILabel().then {
            $0.setLabelStyle(text: text, font: .bold, size: 30, color: .black)
        }
    }
    
}
