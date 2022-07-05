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
        label.changeLabelStyle(text: "", size: 20)
        
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.changeLabelStyle(text: "", size: 30)
        
        return label
    }()
    
    lazy var timerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.circle"), for: .normal)
        button.addTarget(
            self,
            action: #selector(timerButtonTapped(_:)),
            for: .touchUpInside)
        
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
        self.backgroundColor = .white
        self.selectionStyle = .none
        
        [
            titleLabel,
            timeLabel,
            timerButton,
        ]
            .forEach { contentView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.left.top.equalToSuperview().inset(10)
        }
        
        timeLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(10)
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        timerButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(timerButton.snp.height)
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
