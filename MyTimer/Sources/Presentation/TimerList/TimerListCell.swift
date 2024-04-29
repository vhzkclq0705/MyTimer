//
//  TimerListCell.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/29.
//

import UIKit
import SnapKit
import Then

/// Cell for timers of CollectionView
final class TimerListCell: UICollectionViewCell {
    
    // MARK:  UI
    
    lazy var subView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 5
        $0.layer.borderColor = UIColor.CustomColor(.purple1).cgColor
        $0.layer.borderWidth = 1.5
    }
    
    lazy var titleLabel = UILabel().then {
        $0.setLabelStyle(
            text: "",
            font: .bold,
            size: 18,
            color: .black)
    }
    
    lazy var timeLabel = UILabel().then {
        $0.setLabelStyle(
            text: "",
            font: .bold,
            size: 20,
            color: .black)
    }
    
    lazy var timerButton = UIButton().then {
        $0.setImage(
            UIImage(named: "playCircle"),
            for: .normal)
        $0.addTarget(
            self,
            action: #selector(timerButtonTapped(_:)),
            for: .touchUpInside)
    }
    
    // MARK: Properties
    
    static let id = "timerListCell"
    
    // MARK: Button tap handler
    
    var timerButtonTapHandler: (() -> Void)?
    
    // MARK: init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureLayout()
    }
    
    // MARK: Configure
    
    private func configureUI() {
        backgroundColor = .clear
        
        [
            titleLabel,
            timeLabel,
            timerButton,
        ]
            .forEach { subView.addSubview($0) }
        
        contentView.addSubview(subView)
    }
    
    private func configureLayout() {
        subView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(7)
            $0.left.right.equalToSuperview()
        }
        
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
    
    // MARK: Update UI
    
    func updateUI(title: String, min: Int, sec: Int) {
        let mintoStr = String(format: "%02d", min)
        let sectoStr = String(format: "%02d", sec)
        titleLabel.text = title
        timeLabel.text = "\(mintoStr):\(sectoStr)"
    }
    
    // MARK: Actions
    
    @objc private func timerButtonTapped(_ sender: UIButton) {
        timerButtonTapHandler?()
    }
    
}
