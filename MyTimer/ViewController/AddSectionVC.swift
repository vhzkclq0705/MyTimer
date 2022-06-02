//
//  AddSectionVC.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/31.
//

import UIKit
import SnapKit

// ViewController for AddSectionView
class AddSectionVC: UIViewController {
    
    // MARK: - Create UI items
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
    
    lazy var subView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        
        return view
    }()
    
    
    // MARK: - Funcs for life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(
            self, name: NSNotification.Name(rawValue: "reload"), object: nil)
    }
}

// MARK: - Funcs for setup UI
extension AddSectionVC {
    func setup() {
        view.backgroundColor = .clear
        
        [titleLabel, textField, okButton, cancleButton]
            .forEach { subView.addSubview($0) }
        
        view.addSubview(subView)
        
        subView.snp.makeConstraints {
            let width: CGFloat = view.bounds.width * 1 / 4
            let heigth: CGFloat = view.bounds.height * 2 / 5
            
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.left.right.equalToSuperview().inset(width)
            $0.top.bottom.equalToSuperview().inset(heigth)
        }
        
        textField.snp.makeConstraints {
            $0.centerX.equalTo(subView)
            $0.centerY.equalTo(subView)
            $0.left.right.equalTo(subView).inset(30)
            $0.height.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(textField.snp.top).offset(-15)
            $0.centerX.equalTo(subView)
        }
        
        okButton.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(15)
            $0.right.equalTo(subView).inset(30)
            $0.left.equalTo(textField.snp.centerX).offset(20)
        }
        
        cancleButton.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(15)
            $0.left.equalTo(subView).inset(30)
            $0.right.equalTo(textField.snp.centerX).offset(-20)
        }
    }
}

// MARK: - Funcs for Button actions
extension AddSectionVC {
    @objc func reload() {
        dismiss(animated: true)
    }
    
    @objc func okButtonTapped(_ sender: UIButton) {
        guard let term = textField.text, term.isEmpty == false else { return }
        TimerManager.shared.addSection(term)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil, userInfo: nil)
        
        dismiss(animated: true)
    }
    
    @objc func cancleButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

// MARK: - Funcs for TextField
extension AddSectionVC: UITextFieldDelegate {
    
}
