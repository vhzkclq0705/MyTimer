//
//  TimerListCell.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/29.
//

import UIKit
import SnapKit

// Cell for TableView
class TimerListCell: UITableViewCell {
    
    static let id = "timerListCell"
    
    // MARK: - Create UI items
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: "",
            font: .bold,
            size: 18)
        
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: "",
            font: .bold,
            size: 20)
        
        return label
    }()
    
    lazy var timerButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(named: "playCircle"),
            for: .normal)
        
        return button
    }()
    
    // MARK: - Button tap handler
    var timerButtonTapHandler: (() -> Void)?
    
    // MARK: - Cell init
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
}

extension TimerListCell {
    // MARK: - Setup UI
    func setup() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.CustomColor(.purple1).cgColor
        self.layer.borderWidth = 1.5
        
        [
            titleLabel,
            timeLabel,
            timerButton,
        ]
            .forEach { contentView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(15)
        }
        
        timeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(timerButton.snp.left).offset(-9)
        }
        
        timerButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Update UI
    func updateUI(title: String, min: Int, sec: Int) {
        let mintoStr = String(format: "%02d", min)
        let sectoStr = String(format: "%02d", sec)
        titleLabel.text = title
        timeLabel.text = "\(mintoStr):\(sectoStr)"
    }
    
    // MARK: - Button action
    @objc func timerButtonTapped(_ sender: UIButton) {
        timerButtonTapHandler?()
    }
}
