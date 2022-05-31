//
//  AddSectionVC.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/30.
//

import UIKit
import SnapKit

class AddSectionView: UIView {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "섹션을 추가하세요!"
        label.textColor = Colors.color(8)
        label.font = .systemFont(ofSize: 20, weight: .bold)
        
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.setupDetailTextField("섹션 제목")
        textField.delegate = self

        return textField
    }()
    
    lazy var okButton: UIButton = {
        let button = UIButton()
        button.setupDetailButton()
        button.setTitle("확인", for: .normal)
        button.addTarget(self, action: #selector(okButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var cancleButton: UIButton = {
        let button = UIButton()
        button.setupDetailButton()
        button.setTitle("취소", for: .normal)
        button.addTarget(self, action: #selector(cancleButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddSectionView {
    func setup() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 15
        
        [titleLabel, textField, okButton, cancleButton]
            .forEach { self.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        textField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(30)
            $0.height.equalTo(30)
        }
        
        okButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(30)
            $0.right.equalToSuperview().inset(30)
            $0.left.equalTo(textField.snp.centerX).offset(20)
        }
        
        cancleButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(30)
            $0.left.equalToSuperview().inset(30)
            $0.right.equalTo(textField.snp.centerX).offset(-20)
        }
        
    }
    
    @objc func okButtonTapped(_ sender: UIButton) {
        guard let term = textField.text, term.isEmpty == false else { return }
        TimerManager.shared.addSection(term)
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: "reload"),
            object: nil, userInfo: nil)
        self.removeFromSuperview()
    }
    
    @objc func cancleButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: "reload"),
            object: nil, userInfo: nil)
        self.removeFromSuperview()
    }
}

extension AddSectionView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
}
