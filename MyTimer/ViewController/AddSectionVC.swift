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
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.changeLabelStyle(
            text: "섹션을 추가하세요!",
            size: 20,
            color: Colors.color(7))
        
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.setupDetailTextField("운동")
        textField.delegate = self
        
        return textField
    }()
    
    lazy var sectionLabel: UILabel = {
        let label = UILabel()
        label.changeLabelStyle(
            text: "섹션",
            size: 15,
            color: Colors.color(7))
        
        return label
    }()
    
    lazy var okButton: UIButton = {
        let button = UIButton()
        button.setupDetailButton("확인")
        button.addTarget(
            self,
            action: #selector(okButtonTapped(_:)),
            for: .touchUpInside)
        
        return button
    }()
    
    lazy var cancleButton: UIButton = {
        let button = UIButton()
        button.setupDetailButton("취소")
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
        view.backgroundColor = .clear
        
        [
            titleLabel,
            textField,
            sectionLabel,
            okButton,
            cancleButton,
        ]
            .forEach { subView.addSubview($0) }
        
        view.addSubview(subView)
        
        subView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.right.equalTo(textField).inset(-50)
            $0.top.bottom.equalTo(textField).inset(-70)
        }
        
        textField.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(30)
        }
        
        sectionLabel.snp.makeConstraints {
            $0.left.equalTo(textField)
            $0.bottom.equalTo(textField.snp.top).offset(-5)
        }
        
        titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(sectionLabel.snp.top).offset(-10)
            $0.centerX.equalTo(textField)
        }
        
        okButton.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(20)
            $0.right.equalTo(textField)
            $0.left.equalTo(textField.snp.centerX).offset(20)
        }
        
        cancleButton.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(20)
            $0.left.equalTo(textField)
            $0.right.equalTo(textField.snp.centerX).offset(-20)
        }
    }
}

// MARK: TextField
extension AddSectionVC: UITextFieldDelegate {
    // Limit TextField range
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String)
    -> Bool {
        guard let text = textField.text,
              let stringRange = Range(range, in: text) else {
            return false
        }
        let updatedText = text.replacingCharacters(
            in: stringRange,
            with: string)
        
        return updatedText.count <= 8
    }
}

// MARK: - Button actions
extension AddSectionVC {
    @objc func reload() {
        dismiss(animated: true)
    }
    
    @objc func okButtonTapped(_ sender: UIButton) {
        guard let term = textField.text, term.isEmpty == false else {
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
