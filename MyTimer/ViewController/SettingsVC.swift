//
//  SettingsVC.swift
//  MyTimer
//
//  Created by 권오준 on 2022/06/07.
//

import UIKit
import SnapKit

// ViewController for settings
class SettingsVC: UIViewController {
    
    // MARK: - Create UI items
    let backgroundView: UIView = {
        let view = UIView()
        view.setBackgroundView()
        
        return view
    }()
    
    lazy var goalLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: "각오 한 마디",
            font: .bold,
            size: 15,
            color: .black)
        
        return label
    }()
    
    lazy var goalTextField: UITextView = {
        let textView = UITextView()
        textView.setTextView("자신의 각오 한 마디를 입력해주세요")
        textView.textContainerInset = UIEdgeInsets(
            top: 15,
            left: 12,
            bottom: 15,
            right: 12)
        textView.delegate = self
        
        return textView
    }()
    
    lazy var alarmLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: "알람 소리 설정",
            font: .bold,
            size: 15,
            color: .black)
        
        return label
    }()
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        return pickerView
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(named: "playCircleLarge"),
            for: .normal)
        button.addTarget(
            self,
            action: #selector(playAlarmSound(_:)),
            for: .touchUpInside)
        
        return button
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
    
    let topBorder: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.CustomColor(.gray1)
        
        return view
    }()
    
    let bottomBorder: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.CustomColor(.gray1)
        
        return view
    }()
    
    let alaramView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    lazy var subView: UIView = {
        let view = UIView()
        view.setupSubView()
        
        return view
    }()
    
    // MARK: - Property
    let viewModel = SettingsViewModel()
    
    // MARK: - Funcs for life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - Setup UI
extension SettingsVC {
    func setupUI() {
        view.backgroundColor = .clear
        
        [
            pickerView,
            topBorder,
            bottomBorder,
            playButton,
        ]
            .forEach { alaramView.addSubview($0) }
        
        [
            goalLabel,
            goalTextField,
            alarmLabel,
            alaramView,
            okButton,
            cancleButton
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
            $0.height.equalTo(434)
        }
        
        goalLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(37)
            $0.left.right.equalToSuperview().inset(18)
        }
        
        goalTextField.snp.makeConstraints {
            $0.top.equalTo(goalLabel.snp.bottom).offset(7)
            $0.left.right.equalTo(goalLabel)
            $0.height.equalTo(81)
        }
        
        alarmLabel.snp.makeConstraints {
            $0.top.equalTo(goalTextField.snp.bottom).offset(17)
            $0.left.right.equalTo(goalLabel)
        }
        
        alaramView.snp.makeConstraints {
            $0.top.equalTo(alarmLabel.snp.bottom).offset(17)
            $0.bottom.equalTo(cancleButton.snp.top).offset(-35)
            $0.left.right.equalTo(goalLabel)
        }
        
        pickerView.snp.makeConstraints {
            $0.top.bottom.left.equalToSuperview()
            $0.right.equalTo(playButton.snp.left).offset(-15)
        }
        
        topBorder.snp.makeConstraints {
            $0.centerY.equalTo(pickerView).offset(-17.5)
            $0.left.right.equalTo(pickerView)
            $0.height.equalTo(1)
        }
        
        bottomBorder.snp.makeConstraints {
            $0.centerY.equalTo(pickerView).offset(17.5)
            $0.left.right.equalTo(pickerView)
            $0.height.equalTo(1)
        }
        
        playButton.snp.makeConstraints {
            $0.centerY.equalTo(pickerView)
            $0.right.equalToSuperview()
            $0.width.height.equalTo(37)
        }
        
        okButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.equalTo(goalTextField.snp.centerX)
            $0.right.equalToSuperview()
            $0.height.equalTo(59)
        }
        
        cancleButton.snp.makeConstraints {
            $0.top.equalTo(okButton)
            $0.left.equalToSuperview()
            $0.right.equalTo(goalTextField.snp.centerX)
            $0.height.equalTo(59)
        }
    }
}

extension SettingsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int)
    -> Int {
        return viewModel.numOfRows(component)
    }
    
    func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int) {
            viewModel.didSelectAlarm(row)
        }
    
    // PickerView item UI
    func pickerView(
        _ pickerView: UIPickerView,
        viewForRow row: Int,
        forComponent component: Int,
        reusing view: UIView?)
    -> UIView {
        pickerView.subviews.forEach {
            $0.backgroundColor = .clear
        }
        
        return viewModel.componentsLabel(row)
    }
    
    func pickerView(
        _ pickerView: UIPickerView,
        rowHeightForComponent component: Int)
    -> CGFloat {
        return 35
    }
}

extension SettingsVC {
    @objc func okButtonTapped(_ sender: UIButton) {
        stopAudio()
        
        guard let goal = goalLabel.text,
              goal.isEmpty == false else {
            return
        }
        
        viewModel.save(goalTextField.text)
        
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
    
    @objc func playAlarmSound(_ sedner: UIButton) {
        stopAudio()
        playAudio(false)
    }
}

extension SettingsVC: UITextViewDelegate {
    // Limit TextField range
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = .black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" || textView.text == nil {
            textView.text = "자신의 각오 한 마디를 입력해주세요"
            textView.textColor = UIColor.CustomColor(.gray1)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange,
        replacementText text: String) -> Bool {
        guard let term = textView.text,
              let stringRange = Range(range, in: term) else {
            return false
        }
        let updatedText = term.replacingCharacters(
            in: stringRange,
            with: text)
        
        return updatedText.count <= 35
    }
}
