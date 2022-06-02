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

    lazy var sectionLable: UITextField = {
        let textField = UITextField()
        textField.setupDetailTextField("섹션 선택")
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
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.setupDetailTextField("타이머 이름")
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
        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(
            self, name: NSNotification.Name(rawValue: "reload"), object: nil)
    }
}

// MARK: - Funcs for setup UI
extension AddTimerVC {
    func setup() {
        view.backgroundColor = .clear
        
        viewModel.loadSections()
        initDropDown()
        setupDropDown()
        
        [sectionLable, sectionButton]
            .forEach { sectionView.addSubview($0) }
        
        [titleLabel, sectionView, textField,
         pickerView, okButton, cancleButton]
            .forEach { subView.addSubview($0) }
        
        view.addSubview(subView)
        
        subView.snp.makeConstraints {
            let width: CGFloat = view.bounds.width * 1 / 5
            let heigth: CGFloat = view.bounds.height * 1 / 4
            
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.left.right.equalToSuperview().inset(width)
            $0.top.bottom.equalToSuperview().inset(heigth)
        }
        
        pickerView.snp.makeConstraints {
            $0.centerY.equalTo(subView).offset(35)
            $0.left.right.equalTo(subView).inset(10)
            $0.height.equalTo(120)
        }
        
        titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(sectionView.snp.top).offset(-15)
            $0.centerX.equalToSuperview()
        }
        
        sectionView.snp.makeConstraints {
            $0.bottom.equalTo(textField.snp.top).offset(-15)
            $0.left.right.equalToSuperview().inset(30)
            $0.height.equalTo(30)
        }
        
        sectionLable.snp.makeConstraints {
            $0.top.left.bottom.equalTo(sectionView)
            $0.right.equalTo(sectionButton.snp.left)
        }
        
        sectionButton.snp.makeConstraints {
            $0.top.right.bottom.equalTo(sectionView)
            $0.height.equalTo(sectionButton.snp.width)
        }
        
        textField.snp.makeConstraints {
            $0.bottom.equalTo(pickerView.snp.top).offset(-15)
            $0.left.right.equalToSuperview().inset(30)
            $0.height.equalTo(30)
        }
        
        okButton.snp.makeConstraints {
            $0.top.equalTo(pickerView.snp.bottom).offset(15)
            $0.right.equalToSuperview().inset(30)
            $0.left.equalTo(textField.snp.centerX).offset(20)
        }
        
        cancleButton.snp.makeConstraints {
            $0.top.equalTo(pickerView.snp.bottom).offset(15)
            $0.left.equalToSuperview().inset(30)
            $0.right.equalTo(textField.snp.centerX).offset(-20)
        }
    }
    
    func setupDropDown() {
        dropDown.dataSource = viewModel.sections
        dropDown.anchorView = sectionView
        dropDown.bottomOffset = CGPoint(x: 0, y: 30)
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.viewModel.section = index
            self?.sectionLable.text = item
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
    
}

// MARK: - Funcs for Button actions
extension AddTimerVC {
    @objc func okButtonTapped(_ sender: UIButton) {
        guard let section = sectionLable.text, section.isEmpty == false else { return }
        guard let title = textField.text, title.isEmpty == false else { return }
        viewModel.addTimer(title: title)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil, userInfo: nil)
        
        dismiss(animated: true)
    }
    
    @objc func cancleButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc func dropDownTapped(_ sender: UIButton) {
        dropDown.show()
        sectionButton.isSelected = true
    }
}
