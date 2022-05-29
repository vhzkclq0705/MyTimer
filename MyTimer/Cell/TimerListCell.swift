//
//  TimerListCell.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/29.
//

import UIKit
import SnapKit

class TimerListCell: UITableViewCell {
    
    static let id = "timerListCell"
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .regular)
        
        return label
    }()
    
    lazy var timeSetButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black , for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        
        return button
    }()
    
    lazy var timerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "timer"), for: .normal)
        button.layer.borderColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        button.layer.borderWidth = 1
        
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        config.background.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        config.preferredSymbolConfigurationForImage =  UIImage.SymbolConfiguration(pointSize: 20)
        button.configuration = config
        
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
}

extension TimerListCell {
    func setup() {
        self.backgroundColor = .white
        self.selectionStyle = .none
        
        [titleLabel, timeSetButton, timerButton].forEach { contentView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-200)
            $0.centerY.equalToSuperview()
        }
        
        timeSetButton.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.right).offset(10)
            $0.centerY.equalToSuperview()
        }
        
        timerButton.snp.makeConstraints {
            $0.left.equalTo(timeSetButton.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }
    }
    
    func updateUI(title: String, time: String) {
        titleLabel.text = title
        timeSetButton.setTitle(time, for: .normal)
    }
}
