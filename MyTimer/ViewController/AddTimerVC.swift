//
//  AddTimerVC.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/31.
//

import UIKit
import SnapKit
import DropDown

// ViewController for add timer
class AddTimerVC: UIViewController {
    
    // MARK: - Property
    let addTimerView = SetTimerView()
    let viewModel = AddTimerViewModel()
    let dropDown = DropDown()
    
    // MARK: - Life cycle
    override func loadView() {
        view = addTimerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadSections()
        setupDropDown()
        setViewController()
        initDropDown()
    }
    
    // MARK: - Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Setup
    func setViewController() {
        addTimerView.pickerView.delegate = self
        addTimerView.pickerView.dataSource = self
        addTimerView.timerTextField.delegate = self
        addTimerView.sectionButton.addTarget(
            self,
            action: #selector(dropDownTapped(_:)),
            for: .touchUpInside)
        addTimerView.okButton.addTarget(
            self,
            action: #selector(okButtonTapped(_:)),
            for: .touchUpInside)
        addTimerView.cancleButton.addTarget(
            self,
            action: #selector(cancleButtonTapped(_:)),
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
        dropDown.dataSource = viewModel.sections
        dropDown.anchorView = addTimerView.sectionView
        dropDown.bottomOffset = CGPoint(x: 0, y: 40)
        dropDown.selectionAction = { index, item in
            self.viewModel.section = index
            self.addTimerView.sectionTextField.text = item
            self.addTimerView.sectionTextField.textColor = .black
            self.addTimerView.sectionTextField.layer.borderColor = UIColor.CustomColor(.gray1).cgColor
            self.addTimerView.alertSectionLabel.alpha = 0
            self.addTimerView.sectionButton.isSelected = false
        }
        dropDown.cancelAction = {
            self.addTimerView.sectionButton.isSelected = false
        }
    }
    
    // MARK: - funcs
    func checkTextField() {
        guard let section = addTimerView.sectionTextField.text,
              section != "섹션을 선택해주세요",
              section.isEmpty == false else {
            addTimerView.sectionTextField.text = "섹션을 선택해주세요"
            addTimerView.sectionTextField.textColor = UIColor.CustomColor(.gray1)
            addTimerView.sectionTextField.layer.borderColor = UIColor.CustomColor(.red).cgColor
            addTimerView.alertSectionLabel.alpha = 1
            return
        }
        guard let title = addTimerView.timerTextField.text,
              title != "타이머 이름을 입력해주세요",
              title.isEmpty == false else {
            addTimerView.timerTextField.text = "타이머 이름을 입력해주세요"
            addTimerView.timerTextField.textColor = UIColor.CustomColor(.gray1)
            addTimerView.timerTextField.layer.borderColor = UIColor.CustomColor(.red).cgColor
            addTimerView.alertTimerLabel.alpha = 1
            return
        }
        
        viewModel.addTimer(title: title)
        notifyReloadAndDismiss()
    }
    
    // MARK: - Button actions
    @objc func okButtonTapped(_ sender: UIButton) {
        checkTextField()
    }
    
    @objc func cancleButtonTapped(_ sender: UIButton) {
        notifyReloadAndDismiss()
    }
    
    @objc func dropDownTapped(_ sender: UIButton) {
        dropDown.show()
        addTimerView.sectionButton.isSelected = !addTimerView.sectionButton.isSelected
    }
}

// MARK: - PickerView
extension AddTimerVC: UIPickerViewDelegate,
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

// MARK: - TextField
extension AddTimerVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = .black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if addTimerView.timerTextField.text == "" {
            addTimerView.timerTextField.text = "타이머 이름을 입력해주세요"
            addTimerView.timerTextField.textColor = UIColor.CustomColor(.gray1)
        } else {
            addTimerView.timerTextField.layer.borderColor = UIColor.CustomColor(.gray1).cgColor
            addTimerView.alertTimerLabel.alpha = 0
        }
    }

    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String)
    -> Bool {
        guard let term = addTimerView.timerTextField.text,
              let stringRange = Range(range, in: term) else {
            return false
        }
        let updatedText = term.replacingCharacters(
            in: stringRange,
            with: text)
        
        return updatedText.count <= 10
    }
}
