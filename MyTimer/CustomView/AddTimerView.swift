//
//  AddTimerView.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/30.
//

import UIKit

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
        
    }
}
