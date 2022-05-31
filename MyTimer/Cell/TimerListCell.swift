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
        label.font = .systemFont(ofSize: 20, weight: .bold)
        
        return label
    }()
    
    lazy var timeSetButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black , for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .bold)
        
        return button
    }()
    
    lazy var timerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "timer"), for: .normal)
        button.layer.borderColor = Colors.color(0).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .red
        config.background.backgroundColor = .white
        config.preferredSymbolConfigurationForImage =  UIImage.SymbolConfiguration(pointSize: 15, weight: .bold)
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
            $0.left.equalToSuperview().inset(10)
            $0.right.equalTo(timeSetButton.snp.left).offset(-20)
            $0.centerY.equalToSuperview()
        }
        
        timeSetButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        timerButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(timerButton.snp.height)
        }
    }
    
    func updateUI(title: String, min: Int, sec: Int) {
        let mintoStr = String(format: "%02d", min)
        let sectoStr = String(format: "%02d", sec)
        titleLabel.text = title
        timeSetButton.setTitle("\(mintoStr):\(sectoStr)", for: .normal)
    }
}
