//
//  TimerListCell.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/29.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

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
    }
    
    // MARK: Properties
    
    static let id = "timerListCell"
    var disposeBag = DisposeBag()
    
    // MARK: Button tap handler
    
    var timerButtonTapHandler = PublishRelay<Void>()
    
    // MARK: init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupBindings()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureLayout()
    }
    
    // MARK: Configure
    
    private func setupBindings() {
        timerButton.rx.tap
            .bind(to: timerButtonTapHandler)
            .disposed(by: disposeBag)
    }
    
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
            $0.top.bottom.equalToSuperview().inset(5)
            $0.left.right.equalToSuperview().inset(20)
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
    
    func updateUI(timer: RxMyTimer) {
        let mintoStr = String(format: "%02d", timer.min)
        let sectoStr = String(format: "%02d", timer.sec)
        titleLabel.text = timer.title
        timeLabel.text = "\(mintoStr):\(sectoStr)"
    }
    
}
