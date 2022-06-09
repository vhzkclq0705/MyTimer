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
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        
        return label
    }()
    
    lazy var timeSetButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black , for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .bold)
        button.addTarget(self, action: #selector(timeSetButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var timerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.circle"), for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(timerButtonTapped(_:)), for: .touchUpInside)
        
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = .white
        config.preferredSymbolConfigurationForImage =  UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        button.configuration = config
        
        return button
    }()
    
    // MARK: - Button tap handlers
    var timeSetButtonTapHandler: (() -> Void)?
    var timerButtonTapHandler: (() -> Void)?
    
    // MARK: - Funcs for life cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
}

// MARK: - Funcs for UI
extension TimerListCell {
    // Setup UI
    func setup() {
        self.backgroundColor = .white
        self.selectionStyle = .none
        
        [titleLabel, timeSetButton, timerButton].forEach { contentView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.left.top.equalToSuperview().inset(10)
        }
        
        timeSetButton.snp.makeConstraints {
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
    
    // Update UI
    func updateUI(title: String, min: Int, sec: Int, color: UIColor) {
        let mintoStr = String(format: "%02d", min)
        let sectoStr = String(format: "%02d", sec)
        titleLabel.text = title
        timeSetButton.setTitle("\(mintoStr):\(sectoStr)", for: .normal)
        timerButton.tintColor = color
    }
    
    @objc func timeSetButtonTapped(_ sender: UIButton) {
        timeSetButtonTapHandler?()
    }
    
    @objc func timerButtonTapped(_ sender: UIButton) {
        timerButtonTapHandler?()
    }
}
