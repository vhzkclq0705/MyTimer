//
//  SetTimerVC.swift
//  MyTimer
//
//  Created by 권오준 on 2022/06/03.
//

import UIKit
import SnapKit

class SetTimerVC: UIViewController {

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "시간을 재설정하세요!"
        label.textColor = Colors.color(8)
        label.font = UIFont(name: "establishRoomNo703", size: 20)
        
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
    
    let viewModel = SetTimerViewModel()
    var timer: MyTimer!
    var timerIndexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

}

extension SetTimerVC {
    func setupUI() {
        view.backgroundColor = .clear
        
        pickerView.selectRow(timer.min, inComponent: 0, animated: true)
        pickerView.selectRow(timer.sec, inComponent: 2, animated: true)
        
        [ titleLabel, pickerView, okButton, cancleButton]
            .forEach { subView.addSubview($0) }
        
        view.addSubview(subView)
        
        subView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.left.right.equalTo(pickerView).inset(-50)
            $0.top.equalTo(pickerView).offset(-70)
            $0.bottom.equalTo(pickerView).offset(70)
        }
        
        pickerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(120)
        }
        
        titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(pickerView.snp.top).offset(-15)
            $0.centerX.equalToSuperview()
        }
        
        okButton.snp.makeConstraints {
            $0.top.equalTo(pickerView.snp.bottom).offset(15)
            $0.right.equalToSuperview().inset(30)
            $0.left.equalTo(pickerView.snp.centerX).offset(20)
        }
        
        cancleButton.snp.makeConstraints {
            $0.top.equalTo(pickerView.snp.bottom).offset(15)
            $0.left.equalToSuperview().inset(30)
            $0.right.equalTo(pickerView.snp.centerX).offset(-20)
        }
        
    }
}

// MARK: - Funcs for UIPickerView(Same as AddTimerVC)
extension SetTimerVC: UIPickerViewDelegate, UIPickerViewDataSource {
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

extension SetTimerVC {
    @objc func okButtonTapped(_ sender: UIButton) {
        viewModel.setTimer(timerIndexPath)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil, userInfo: nil)
        
        dismiss(animated: true)
    }
    
    @objc func cancleButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil, userInfo: nil)
        
        dismiss(animated: true)
    }
}
