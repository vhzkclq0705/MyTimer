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
    
    // MARK: - Create UI items
    let backgroundView: UIView = {
        let view = UIView()
        view.setBackgroundView()
        
        return view
    }()
    
    lazy var sectionLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: "섹션 선택",
            font: .bold,
            size: 15,
            color: .black)
        
        return label
    }()
    
    lazy var sectionTextField: UITextView = {
        let textView = UITextView()
        textView.setTextView("섹션을 선택해주세요")
        textView.isUserInteractionEnabled = false
        
        return textView
    }()
    
    let alertSectionLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: "섹션을 선택해주세요",
            font: .medium,
            size: 12,
            color: UIColor.CustomColor(.red))
        label.alpha = 0
        
        return label
    }()
    
    lazy var sectionButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(named: "arrowDown")?
                .withTintColor(.black),
            for: .normal)
        button.setImage(
            UIImage(named: "arrowUp")?
                .withTintColor(.black),
            for: .selected)
        button.addTarget(
            self,
            action: #selector(dropDownTapped(_:)),
            for: .touchUpInside)
        
        return button
    }()
    
    lazy var sectionView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: "타이머 이름",
            font: .bold,
            size: 15,
            color: .black)
        
        return label
    }()
    
    lazy var timerTextField: UITextView = {
        let textView = UITextView()
        textView.setTextView("타이머 이름을 입력해주세요")
        textView.delegate = self
        
        return textView
    }()
    
    let alertTimerLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: "타이머 이름을 입력해주세요",
            font: .medium,
            size: 12,
            color: UIColor.CustomColor(.red))
        label.alpha = 0
        
        return label
    }()
    
    lazy var timerSettingLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: "타이머 설정",
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
    
    // MARK: - Property
    let viewModel = AddTimerViewModel()
    let dropDown = DropDown()
    var isSetting = false
    
    // MARK: - Funcs for life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadSections()
        setupDropDown()
        setupUI()
        initDropDown()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(
            self, name: NSNotification.Name(rawValue: "reload"), object: nil)
    }
    
    // MARK: - Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - Setup UI
extension AddTimerVC {
    func setupUI() {
        if isSetting {
            
        }
        
        [
            sectionTextField,
            sectionButton,
        ]
            .forEach { sectionView.addSubview($0) }
        
        [
            sectionLabel,
            sectionView,
            alertSectionLabel,
            timerTextField,
            alertTimerLabel,
            timerLabel,
            timerSettingLabel,
            pickerView,
            okButton,
            cancleButton,
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
        
        sectionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(37)
            $0.left.right.equalToSuperview().inset(18)
        }
        
        sectionView.snp.makeConstraints {
            $0.top.equalTo(sectionLabel.snp.bottom).offset(7)
            $0.left.right.equalTo(sectionLabel)
            $0.height.equalTo(51)
        }
        
        sectionTextField.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        sectionButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(11)
        }
        
        alertSectionLabel.snp.makeConstraints {
            $0.top.equalTo(sectionTextField.snp.bottom).offset(3)
            $0.right.equalTo(sectionTextField)
        }
        
        timerLabel.snp.makeConstraints {
            $0.top.equalTo(sectionView.snp.bottom).offset(17)
            $0.left.right.equalTo(sectionLabel)
        }
        
        timerTextField.snp.makeConstraints {
            $0.top.equalTo(timerLabel.snp.bottom).offset(7)
            $0.left.right.equalTo(sectionLabel)
            $0.height.equalTo(51)
        }
        
        alertTimerLabel.snp.makeConstraints {
            $0.top.equalTo(timerTextField.snp.bottom).offset(3)
            $0.right.equalTo(timerTextField)
        }
        
        timerSettingLabel.snp.makeConstraints {
            $0.top.equalTo(timerTextField.snp.bottom).offset(17)
            $0.left.right.equalTo(sectionLabel)
        }
        
        pickerView.snp.makeConstraints {
            $0.top.equalTo(timerSettingLabel.snp.bottom).offset(7)
            $0.left.right.equalToSuperview().inset(60)
            $0.height.equalTo(100)
        }
        
        okButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.equalTo(timerTextField.snp.centerX)
            $0.right.equalToSuperview()
            $0.height.equalTo(59)
        }
        
        cancleButton.snp.makeConstraints {
            $0.top.equalTo(okButton)
            $0.left.equalToSuperview()
            $0.right.equalTo(timerTextField.snp.centerX)
            $0.height.equalTo(59)
        }
    }
    
    // Init attributes of DropDown
    func initDropDown() {
        DropDown.appearance().textColor = .darkGray
        DropDown.appearance().selectedTextColor = .black
        DropDown.appearance().backgroundColor = .white
        DropDown.appearance().selectionBackgroundColor = .lightGray
        DropDown.appearance().setupCornerRadius(5)
        dropDown.dismissMode = .automatic
    }
    
    //  Setup DropDown
    func setupDropDown() {
        dropDown.dataSource = viewModel.sections
        dropDown.anchorView = sectionView
        dropDown.bottomOffset = CGPoint(x: 0, y: 30)
        dropDown.selectionAction = { index, item in
            self.viewModel.section = index
            self.sectionTextField.text = item
            self.sectionTextField.textColor = .black
            self.sectionTextField.layer.borderColor = UIColor.CustomColor(.gray1).cgColor
            self.alertSectionLabel.alpha = 0
            self.sectionButton.isSelected = false
        }
        dropDown.cancelAction = {
            self.sectionButton.isSelected = false
        }
    }
}

// MARK: - PickerView
extension AddTimerVC: UIPickerViewDelegate, UIPickerViewDataSource {
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
    // Limit TextField range
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = .black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if sectionTextField.text == "섹션을 선택해주세요" {
            sectionTextField.layer.borderColor = UIColor.CustomColor(.red).cgColor
            alertSectionLabel.alpha = 1
        } else {
            sectionTextField.layer.borderColor = UIColor.CustomColor(.gray1).cgColor
            alertSectionLabel.alpha = 0
        }
        if timerTextField.text == "" || timerTextField.text == nil {
            timerTextField.text = "타이머 이름을 작성해주세요"
            timerTextField.textColor = UIColor.CustomColor(.gray1)
            timerTextField.layer.borderColor = UIColor.CustomColor(.red).cgColor
            alertTimerLabel.alpha = 1
        } else {
            timerTextField.textColor = .black
            timerTextField.layer.borderColor = UIColor.CustomColor(.gray1).cgColor
            alertTimerLabel.alpha = 0
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange,
        replacementText text: String) -> Bool {
        guard let term = timerTextField.text,
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
extension AddTimerVC {
    @objc func okButtonTapped(_ sender: UIButton) {
        guard let section = sectionTextField.text,
              section.isEmpty == false else {
            return
        }
        guard let title = timerTextField.text,
              title.isEmpty == false else {
            return
        }
        viewModel.addTimer(title: title)
        
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
    
    @objc func dropDownTapped(_ sender: UIButton) {
        dropDown.show()
        sectionButton.isSelected = !sectionButton.isSelected
    }
}
