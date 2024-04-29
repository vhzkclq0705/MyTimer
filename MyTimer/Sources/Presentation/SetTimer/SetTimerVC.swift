//
//  SetTimerVC.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/31.
//

import UIKit
import DropDown

// ViewController for add timer
class SetTimerVC: UIViewController {
    
    // MARK: - Property
    let setTimerView = AddORSetTimerView(frame: .zero, feature: .Update)
    let viewModel = SetTimerViewModel()
    let dropDown = DropDown()
    var sectionTitle: String!
    var timer: MyTimer!
    var delegate: SetTimerDelegate?
    
    // MARK: - Life cycle
    override func loadView() {
        view = setTimerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadSections()
        setupDropDown()
        setViewController()
        setTimer()
        initDropDown()
    }
    
    // MARK: - Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Setup
    func setViewController() {
        setTimerView.pickerView.delegate = self
        setTimerView.pickerView.dataSource = self
        setTimerView.timerTextField.delegate = self
        
        setTimerView.sectionButton.addTarget(
            self,
            action: #selector(dropDownTapped(_:)),
            for: .touchUpInside)
        setTimerView.okButton.addTarget(
            self,
            action: #selector(okButtonTapped(_:)),
            for: .touchUpInside)
        setTimerView.cancleButton.addTarget(
            self,
            action: #selector(didTapCancleButton(_:)),
            for: .touchUpInside)
    }
    
    func initDropDown() {
        let dropDownAppearance = DropDown.appearance()
        dropDownAppearance.textColor = .darkGray
        dropDownAppearance.selectedTextColor = .black
        dropDownAppearance.backgroundColor = .white
        dropDownAppearance.selectionBackgroundColor = .lightGray
        dropDownAppearance.setupCornerRadius(5)
        dropDown.dismissMode = .automatic
    }
    
    func setupDropDown() {
        dropDown.dataSource = viewModel.sectionTitles()
        dropDown.anchorView = setTimerView.sectionView
        dropDown.bottomOffset = CGPoint(x: 0, y: 40)
        dropDown.selectionAction = { index, item in
            self.viewModel.selectedSectionTitle = self.viewModel.sections[index].title
            self.setTimerView.sectionTextField.text = item
            self.setTimerView.sectionTextField.textColor = .black
            self.setTimerView.sectionTextField.layer.borderColor = UIColor.CustomColor(.gray1).cgColor
            self.setTimerView.alertSectionLabel.alpha = 0
            self.setTimerView.sectionButton.isSelected = false
        }
        dropDown.cancelAction = {
            self.setTimerView.sectionButton.isSelected = false
        }
    }
    
    // MARK: - Actions
    func setTimer() {
        viewModel.timer = timer
        viewModel.sectionTitle = sectionTitle
        viewModel.selectedSectionTitle = sectionTitle
        setTimerView.sectionTextField.text = sectionTitle
        setTimerView.sectionTextField.textColor = .black
        setTimerView.timerTextField.text = timer.title
        setTimerView.timerTextField.textColor = .black
        
        setTimerView.pickerView.selectRow(
            timer.min,
            inComponent: 0,
            animated: true)
        setTimerView.pickerView.selectRow(
            timer.sec,
            inComponent: 2,
            animated: true)
    }
    
    func checkTextField() {
        guard let title = setTimerView.timerTextField.text,
              title != "타이머 이름을 입력해주세요",
              title.isEmpty == false else {
            setTimerView.timerTextField.text = "타이머 이름을 입력해주세요"
            setTimerView.timerTextField.textColor = UIColor.CustomColor(.gray1)
            setTimerView.timerTextField.layer.borderColor = UIColor.CustomColor(.red).cgColor
            setTimerView.alertTimerLabel.alpha = 1
            return
        }
        
        viewModel.timerTitle = title
        let updatedTimer = viewModel.checkSetting()
        delegate?.updateTimer(section: updatedTimer.0, timer: updatedTimer.1)
        
        changeCompleteView(.setTimer)
    }
    
    @objc func okButtonTapped(_ sender: UIButton) {
        checkTextField()
    }
    
    @objc func dropDownTapped(_ sender: UIButton) {
        dropDown.show()
        setTimerView.sectionButton.isSelected = !setTimerView.sectionButton.isSelected
    }
}

// MARK: - PickerView
extension SetTimerVC: UIPickerViewDelegate,
                      UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return viewModel.numOfComponents
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
            viewModel.didSelectTime(row: row, component: component)
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
        
        return viewModel.componentsLabel(row: row, component: component)
    }
}

// MARK: - TextView
extension SetTimerVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = .black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if setTimerView.timerTextField.text == "" {
            setTimerView.timerTextField.text = "타이머 이름을 입력해주세요"
            setTimerView.timerTextField.textColor = UIColor.CustomColor(.gray1)
        } else {
            setTimerView.timerTextField.layer.borderColor = UIColor.CustomColor(.gray1).cgColor
            setTimerView.alertTimerLabel.alpha = 0
        }
    }

    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String)
    -> Bool {
        guard let term = setTimerView.timerTextField.text,
              let stringRange = Range(range, in: term) else {
            return false
        }
        let updatedText = term.replacingCharacters(
            in: stringRange,
            with: text)
        
        return updatedText.count <= 10
    }
}
