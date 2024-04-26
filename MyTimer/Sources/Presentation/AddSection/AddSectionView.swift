//
//  AddSectionView.swift
//  MyTimer
//
//  Created by 권오준 on 2022/07/11.
//

import UIKit
import SnapKit
import Then

final class AddSectionView: BaseView {
    
    // MARK:  UI
    
    lazy var titleLabel = UILabel().then {
        $0.setLabelStyle(
            text: "섹션 추가",
            font: .bold,
            size: 15,
            color: .black)
    }
    
    lazy var textField = UITextView().then {
        $0.setTextView("섹션 이름을 입력해주세요")
    }
    
    lazy var alertLabel = UILabel().then {
        $0.setLabelStyle(
            text: "섹션 이름을 입력해주세요",
            font: .medium,
            size: 12,
            color: UIColor.CustomColor(.red))
        $0.alpha = 0
    }
    
    lazy var okButton = UIButton().then {
        $0.setSubViewOKButton()
    }
    
    lazy var cancleButton = UIButton().then {
        $0.setSubViewCancleButton()
    }
    
    lazy var subView = UIView().then {
        $0.setupSubView()
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
            titleLabel,
            textField,
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
}
