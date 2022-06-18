//
//  AddTimerVC.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/31.
//

import UIKit
import SnapKit
import DropDown

// ViewController for AddTimerView
class AddTimerVC: UIViewController {
    
    // MARK: - Create UI items
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "타이머를 추가하세요!"
        label.textColor = Colors.color(8)
        label.font = .systemFont(ofSize: 20, weight: .bold)
        
        return label
    }()
    
    lazy var sectionLabel: UILabel = {
        let label = UILabel()
        label.text = "섹션"
        label.textColor = Colors.color(8)
        label.font = .systemFont(ofSize: 15, weight: .bold)
        
        return label
    }()
    
    lazy var sectionTextField: UITextField = {
        let textField = UITextField()
        textField.setupDetailTextField("")
        textField.isUserInteractionEnabled = false
        
        return textField
    }()
    
    lazy var sectionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Colors.color(0)
        button.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
        button.setImage(UIImage(systemName: "arrowtriangle.up.fill"), for: .selected)
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(dropDownTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var sectionView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = "타이머"
        label.textColor = Colors.color(8)
        label.font = .systemFont(ofSize: 15, weight: .bold)
        
        return label
    }()
    
    lazy var timerTextField: UITextField = {
        let textField = UITextField()
        textField.setupDetailTextField("푸시업")
        textField.delegate = self

        return textField
    }()
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
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
    
    lazy var subView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        
        return view
    }()
    
    // MARK: - Create viewModel and dropDown
    let viewModel = AddTimerViewModel()
    let dropDown = DropDown()
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - Funcs for setup UI
extension AddTimerVC {
    func setupUI() {
        view.backgroundColor = .clear
        
        [sectionTextField, sectionButton]
            .forEach { sectionView.addSubview($0) }
        
        [titleLabel, sectionLabel, sectionView, timerTextField,
         timerLabel, pickerView, okButton, cancleButton]
            .forEach { subView.addSubview($0) }
        
        view.addSubview(subView)
        
        subView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.left.right.equalTo(pickerView).inset(-50)
            $0.top.equalTo(pickerView).offset(-190)
            $0.bottom.equalTo(pickerView).offset(70)
        }
        
        pickerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(120)
        }
        
        titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(sectionLabel.snp.top).offset(-10)
            $0.centerX.equalToSuperview()
        }
        
        sectionLabel.snp.makeConstraints {
            $0.left.equalTo(sectionTextField)
            $0.bottom.equalTo(sectionTextField.snp.top).offset(-5)
        }
        
        sectionView.snp.makeConstraints {
            $0.bottom.equalTo(timerLabel.snp.top).offset(-15)
            $0.left.right.equalToSuperview().inset(30)
            $0.height.equalTo(30)
        }
        
        sectionTextField.snp.makeConstraints {
            $0.top.left.bottom.equalTo(sectionView)
            $0.right.equalTo(sectionButton.snp.left)
        }
        
        sectionButton.snp.makeConstraints {
            $0.top.right.bottom.equalTo(sectionView)
            $0.height.equalTo(sectionButton.snp.width)
        }
        
        timerLabel.snp.makeConstraints {
            $0.left.equalTo(timerTextField)
            $0.bottom.equalTo(timerTextField.snp.top).offset(-5)
        }
        
        timerTextField.snp.makeConstraints {
            $0.bottom.equalTo(pickerView.snp.top).offset(-15)
            $0.left.right.equalToSuperview().inset(30)
            $0.height.equalTo(30)
        }
        
        okButton.snp.makeConstraints {
            $0.top.equalTo(pickerView.snp.bottom).offset(15)
            $0.right.equalToSuperview().inset(30)
            $0.left.equalTo(timerTextField.snp.centerX).offset(20)
        }
        
        cancleButton.snp.makeConstraints {
            $0.top.equalTo(pickerView.snp.bottom).offset(15)
            $0.left.equalToSuperview().inset(30)
            $0.right.equalTo(timerTextField.snp.centerX).offset(-20)
        }
    }
    
    // Func for init attributes of DropDown
    func initDropDown() {
        DropDown.appearance().textColor = .darkGray
        DropDown.appearance().selectedTextColor = .black
        DropDown.appearance().backgroundColor = .white
        DropDown.appearance().selectionBackgroundColor = .lightGray
        DropDown.appearance().setupCornerRadius(5)
        dropDown.dismissMode = .automatic
    }
    
    // Func for setup DropDown
    func setupDropDown() {
        dropDown.dataSource = viewModel.sections
        dropDown.anchorView = sectionView
        dropDown.bottomOffset = CGPoint(x: 0, y: 30)
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.viewModel.section = index
            self?.sectionTextField.text = item
            self?.sectionButton.isSelected = false
        }
        dropDown.cancelAction = { [weak self] in
            self?.sectionButton.isSelected = false
        }
    }
}

// MARK: - Funcs for PickerView
extension AddTimerVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
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

// MARK: - Funcs for TextField
extension AddTimerVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 8
    }
}

// MARK: - Funcs for Button actions
extension AddTimerVC {
    @objc func okButtonTapped(_ sender: UIButton) {
        guard let section = sectionTextField.text, section.isEmpty == false else { return }
        guard let title = timerTextField.text, title.isEmpty == false else { return }
        viewModel.addTimer(title: title)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil, userInfo: nil)
        
        dismiss(animated: true)
    }
    
    @objc func cancleButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil, userInfo: nil)
        
        dismiss(animated: true)
    }
    
    @objc func dropDownTapped(_ sender: UIButton) {
        dropDown.show()
        sectionButton.isSelected = true
    }
}
