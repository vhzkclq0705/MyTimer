//
//  AddSectionVC.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/31.
//

import UIKit
import SnapKit

// ViewController for add section
class AddSectionVC: UIViewController {
    
    // MARK: - Create UI items
    let backgroundView: UIView = {
        let view = UIView()
        view.setBackgroundView()
        
        return view
    }()
    
    lazy var titleLabel: UILabel = {
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
        textView.delegate = self
        
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
        button.addTarget(
            self,
            action: #selector(okButtonTapped(_:)),
            for: .touchUpInside)
        
        return button
    }()
    
    lazy var cancleButton: UIButton = {
        let button = UIButton()
        button.setSubViewCancleButton()
        button.addTarget(
            self,
            action: #selector(cancleButtonTapped(_:)),
            for: .touchUpInside)
        
        return button
    }()
    
    lazy var subView: UIView = {
        let view = UIView()
        view.setupSubView()
        
        return view
    }()
    
    
    // MARK: - Funcs for life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name(rawValue: "reload"),
            object: nil)
    }
    
    // MARK: - Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - Setup UI
extension AddSectionVC {
    func setupUI() {
        
        [
            titleLabel,
            textField,
            okButton,
            cancleButton,
            alertLabel,
        ]
            .forEach { subView.addSubview($0) }
        
        [backgroundView, subView]
            .forEach { view.addSubview($0) }
        
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

// MARK: TextField
extension AddSectionVC: UITextViewDelegate {
    // Limit TextField range
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = .black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "섹션 이름을 입력해주세요"
            textView.textColor = UIColor.CustomColor(.gray1)
        } else {
            textView.layer.borderColor = UIColor.CustomColor(.gray1).cgColor
            alertLabel.alpha = 0
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange,
        replacementText text: String) -> Bool {
        guard let term = textField.text,
              let stringRange = Range(range, in: term) else {
            return false
        }
        let updatedText = term.replacingCharacters(
            in: stringRange,
            with: text)
        
        return updatedText.count <= 10
    }
}

// MARK: - Button actions
extension AddSectionVC {
    @objc func reload() {
        dismiss(animated: true)
    }
    
    @objc func okButtonTapped(_ sender: UIButton) {
        guard let term = textField.text,
              term != "섹션 이름을 입력해주세요",
              term.isEmpty == false else {
            textField.text = "섹션 이름을 입력해주세요"
            textField.textColor = UIColor.CustomColor(.gray1)
            textField.layer.borderColor = UIColor.CustomColor(.red).cgColor
            alertLabel.alpha = 1
            return
        }
        
        TimerManager.shared.addSection(term)
        
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: "reload"),
            object: nil,
            userInfo: nil)
        
        dismiss(animated: true)
    }
    
    @objc func cancleButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: "reload"),
            object: nil,
            userInfo: nil)
        
        dismiss(animated: true)
    }
}
