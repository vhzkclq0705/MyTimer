//
//  AddTimerView.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/30.
//

import UIKit
import SnapKit

class AddTimerView: UIView {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "타이머를 추가하세요!"
        label.textColor = Colors.color(8)
        label.font = .systemFont(ofSize: 20, weight: .bold)
        
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.setupDetailTextField("타이머 이름")
        textField.delegate = self

        return textField
    }()
    
    lazy var minPickerView: UIPickerView = {
        let pickerView = UIPickerView()
       // pickerView.setValue(UIColor.black, forKeyPath: "textColor")
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
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
    
    lazy var secPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.tintColor = .black
        pickerView.backgroundColor = .white
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    let viewModel = AddTimerViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddTimerView: UITextFieldDelegate {
    func setup() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 15
        
        [titleLabel, textField, minPickerView, okButton, cancleButton]
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
        
        minPickerView.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(10)
            $0.left.right.equalToSuperview()
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
}

extension AddTimerView {
    @objc func okButtonTapped(_ sender: UIButton) {
        //print(minPickerView)
    }
    
    @objc func cancleButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: "reload"),
            object: nil, userInfo: nil)
        self.removeFromSuperview()
    }
}

extension AddTimerView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return viewModel.numOfComponents
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.numOfRows(component)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.didSelectTime(row: row, component: component)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        pickerView.subviews.forEach {
            $0.backgroundColor = .clear
        }
        
        return viewModel.componentsLabel(row: row, component: component)
    }
}
