//
//  AddSectionView.swift
//  MyTimer
//
//  Created by 권오준 on 2022/07/11.
//

import UIKit
import SnapKit

class AddSectionView: UIView {
    
    // MARK: - UI
    let backgroundView: UIView = {
        let view = UIView()
        view.setBackgroundView()
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: "섹션 추가",
            font: .bold,
            size: 15,
            color: .black)
        
        return label
    }()
    
    lazy var textField: UITextView = {
        let textView = UITextView()
        textView.setTextView("섹션 이름을 입력해주세요")
        
        return textView
    }()
    
    let alertLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: "섹션 이름을 입력해주세요",
            font: .medium,
            size: 12,
            color: UIColor.CustomColor(.red))
        label.alpha = 0
        
        return label
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
            titleLabel,
            textField,
            okButton,
            cancleButton,
            alertLabel,
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
