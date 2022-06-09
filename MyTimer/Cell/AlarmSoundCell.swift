//
//  AlarmSoundCell.swift
//  MyTimer
//
//  Created by 권오준 on 2022/06/07.
//

import UIKit
import SnapKit

class AlarmSoundCell: UITableViewCell {
    
    static let id = "alarmSoundCell"
    
    // MARK: - Create UI items
    lazy var soundLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        
        return label
    }()
    
    lazy var checkButton: UIButton = {
        let button = UIButton()
        button.tintColor = Colors.color(0)
        button.setImage(UIImage(systemName: "checkmark"), for: .selected)
        
        return button
    }()
    
    // MARK: - Funcs for life cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
}

extension AlarmSoundCell {
    // MARK: - Funcs for setup UI
    func setup() {
        contentView.backgroundColor = .white
        
        [soundLabel, checkButton].forEach { contentView.addSubview($0) }
        
        checkButton.snp.makeConstraints {
            $0.left.equalToSuperview().inset(10)
            $0.top.bottom.equalToSuperview().inset(5)
            $0.width.equalTo(checkButton.snp.height)
        }
        
        soundLabel.snp.makeConstraints {
            $0.left.equalTo(checkButton.snp.right).offset(10)
            $0.top.bottom.equalToSuperview().inset(10)
        }
    }
    
    // MARK: - Fucs for update UI
    func updateUI(_ text: String) {
        soundLabel.text = text
        checkButton.isSelected = alarmSound == text ? true : false
    }
}
