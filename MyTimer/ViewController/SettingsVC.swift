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
    
    // MARK: - Property
    let settingsView = SettingsView()
    let viewModel = SettingsViewModel()
    var goal: String!
    
    // MARK: - Life cycle
    override func loadView() {
        view = settingsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setController()
    }
    
    // MARK: - Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Setup
    func setController() {
        settingsView.goalTextField.text = goal
        settingsView.goalTextField.textColor = goal == "자신의 각오 한 마디를 입력해주세요"
        ? UIColor.CustomColor(.gray1) : .black
        
        settingsView.goalTextField.delegate = self
        settingsView.pickerView.delegate = self
        settingsView.pickerView.dataSource = self
        
        settingsView.playButton.addTarget(
            self,
            action: #selector(playAlarmSound(_:)),
            for: .touchUpInside)
        settingsView.okButton.addTarget(
            self,
            action: #selector(okButtonTapped(_:)),
            for: .touchUpInside)
        settingsView.cancleButton.addTarget(
            self,
            action: #selector(didTapCancleButton(_:)),
            for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc func okButtonTapped(_ sender: UIButton) {
        stopAudio()
        
        guard let goal = settingsView.goalLabel.text,
              goal.isEmpty == false else {
            return
        }
        
        viewModel.save(settingsView.goalTextField.text)
        
        changeCompleteView(.settings)
    }
    
    @objc override func didTapCancleButton(_ sender: UIButton) {
        stopAudio()
        notifyReloadAndDismiss()
    }
    
    @objc func playAlarmSound(_ sedner: UIButton) {
        stopAudio()
        playAudio(false)
    }
}

// MARK: - PickerView
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

// MARK: - TextView
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
    
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String)
    -> Bool {
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
