//
//  TimerListHeaderView.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/30.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

// Header view for sections of CollectionView
final class TimerListHeaderView: UICollectionReusableView {
    
    // MARK: UI
    
    lazy var titleLabel = UILabel().then {
        $0.setLabelStyle(
            text: "",
            font: .semibold,
            size: 17,
            color: .black)
    }
    
    lazy var expandButton = UIButton().then {
        $0.setImage(UIImage(named: "arrowDown"), for: .normal)
        $0.setImage(UIImage(named: "arrowUp"), for: .selected)
    }
    
    lazy var updateButton = UIButton().then {
        $0.setImage(UIImage(named: "modify"), for: .normal)
    }
    
    // MARK: Properties
    
    static let id = "timerListHeaderView"
    var disposeBag = DisposeBag()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
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
    
    private func configureUI() {
        backgroundColor = .clear
        
        [
            titleLabel,
            expandButton,
            updateButton
        ]
            .forEach { addSubview($0) }
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview()
        }
        
        expandButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(titleLabel.snp.right).offset(5)
        }
        
        updateButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(expandButton.snp.right).offset(5)
        }
        
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        expandButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        updateButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    func setupBindings(section: Section, completion: @escaping (HeaderButtonType, UUID) -> Void) {
        updateUI(section)
        expandButton.rx.tap.asSignal()
            .emit(with: self, onNext: { owner, _ in
                owner.expandButton.isSelected.toggle()
                completion(.Expand, section.id)
            })
            .disposed(by: disposeBag)
        
        updateButton.rx.tap.asSignal()
            .emit(onNext: { _ in
                completion(.Update, section.id)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Helper Methods
    
    private func updateUI(_ section: Section) {
        titleLabel.text = section.title
        expandButton.isSelected = section.isExpanded
    }
    
}
