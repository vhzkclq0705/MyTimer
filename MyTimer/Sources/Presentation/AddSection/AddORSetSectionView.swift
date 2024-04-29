//
//  AddORSetSectionView.swift
//  MyTimer
//
//  Created by 권오준 on 2022/07/11.
//

import UIKit
import SnapKit
import Then

enum SubViewFeature {
    case Add
    case Update
}

final class AddORSetSectionView: BaseView {
    
    // MARK:  UI
    
    lazy var titleLabel = UILabel().then {
        $0.setLabelStyle(
            text: "",
            font: .bold,
            size: 15,
            color: .black)
    }
    
    lazy var textField = UITextView().then {
        $0.setTextView(placeholder)
    }
    
    lazy var alertLabel = UILabel().then {
        $0.setLabelStyle(
            text: "",
            font: .medium,
            size: 12,
            color: UIColor.CustomColor(.red))
        $0.alpha = 0
    }
    
    lazy var deleteButton = UIButton().then {
        $0.setImage(UIImage(named: "delete"), for: .normal)
    }
    
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
    
    private let placeholder = "섹션 이름"
    private let emptyAlarm = "섹션 이름을 입력해주세요."
    private let exceededAlarm = "섹션 이름은 최대 10자 입니다."
    private var sectionTitle = ""
    
    // MARK: Init
    
    init(frame: CGRect, feature: SubViewFeature) {
        super.init(frame: frame)
        titleLabel.text = feature == .Add ? "섹션 추가" : "섹션 이름 변경"
        deleteButton.isHidden = feature == .Add ? true : false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure
    
    override func configureUI() {
        [
            titleLabel,
            textField,
            deleteButton,
            okButton,
            cancleButton,
            alertLabel,
        ]
            .forEach { subView.addSubview($0) }
        
        addSubview(subView)
    }
    
    override func configureLayout() {
        subView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.right.equalToSuperview().inset(17)
            $0.height.equalTo(220)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(37)
            $0.left.equalTo(textField)
        }
        
        textField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(18)
            $0.height.equalTo(51)
        }
        
        alertLabel.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(3)
            $0.right.equalTo(textField)
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.right.equalToSuperview().inset(15)
        }
        
        okButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.equalTo(textField.snp.centerX)
            $0.right.equalToSuperview()
            $0.height.equalTo(59)
        }
        
        cancleButton.snp.makeConstraints {
            $0.top.equalTo(okButton)
            $0.left.equalToSuperview()
            $0.right.equalTo(textField.snp.centerX)
            $0.height.equalTo(59)
        }
    }
    
    // MARK: TextView Management
    
    func validateText(_ length: Int) {
        if textField.text == placeholder { return }
        switch length {
        case 1..<10:
            alertLabel.alpha = 0
            textField.layer.borderColor = UIColor.CustomColor(.gray1).cgColor
            okButton.isUserInteractionEnabled = true
        default:
            if length > 10 {
                textField.deleteBackward()
            }
            
            alertLabel.text = length == 0 ? emptyAlarm : exceededAlarm
            alertLabel.alpha = 1
            textField.layer.borderColor = UIColor.CustomColor(.red).cgColor
            okButton.isUserInteractionEnabled = false
        }
    }
    
    func startEditingTextView() {
        if textField.text == placeholder {
            textField.text = ""
            textField.textColor = .black
        }
    }
    
    func endEditingTextView() {
        if textField.text.isEmpty {
            textField.text = placeholder
            textField.textColor = .CustomColor(.gray1)
            okButton.isUserInteractionEnabled = false
        }
    }
    
}
