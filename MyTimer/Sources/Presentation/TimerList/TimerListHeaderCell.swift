//
//  TimerListHeaderCell.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/30.
//

import UIKit
import ExpyTableView
import SnapKit
import Then

// Cell for sections of TableView
final class TimerListHeaderCell: UITableViewCell, ExpyTableViewHeaderCell {
    
    // MARK: UI
    
    lazy var titleLabel = UILabel().then {
        $0.setLabelStyle(
            text: "",
            font: .semibold,
            size: 17,
            color: .black)
    }
    
    lazy var detailImageView = UIImageView().then {
        $0.image = UIImage(named: "arrowDown")
    }
    
    lazy var modifyButton = UIButton().then {
        $0.setImage(UIImage(named: "modify"), for: .normal)
        $0.addTarget(
            self,
            action: #selector(didTapModifyButton(_:)),
            for: .touchUpInside)
    }
    
    lazy var clearView = UIButton()
    
    // MARK: Properties
    
    static let id = "timerListHeaderCell"

    // MARK: Button tap handler
    
    var modifyButtonTapHandler: (() -> Void)?
    
    // MARK: Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        selectionStyle = .none
        
        [
            titleLabel,
            detailImageView,
            modifyButton,
            clearView,
        ]
            .forEach { contentView.addSubview($0) }
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview()
        }
        
        detailImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(titleLabel.snp.right).offset(5)
        }
        
        modifyButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(detailImageView.snp.right).offset(5)
        }
        
        clearView.snp.makeConstraints {
            $0.top.bottom.right.equalToSuperview()
            $0.left.equalTo(modifyButton.snp.right)
        }
        
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        detailImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        modifyButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        clearView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    // MARK: Update UI
    
    func updateUI(text: String) {
        titleLabel.text = text
    }
    
    func changeState(_ state: ExpyState, cellReuseStatus cellReuse: Bool) {
        switch state {
        case .willExpand: detailImageView.image = UIImage(named: "arrowUp")
        case .willCollapse: detailImageView.image = UIImage(named: "arrowDown")
        default: break
        }
    }
    
    // MARK: Actions
    
    @objc private func didTapModifyButton(_ sender: UIButton) {
        modifyButtonTapHandler?()
    }
    
}

extension UITableViewCell {
    
//    func showSeparator() {
//        DispatchQueue.main.async {
//            self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        }
//    }
//    
//    func hideSeparator() {
//        DispatchQueue.main.async {
//            self.separatorInset = UIEdgeInsets(top: 0, left: self.bounds.size.width, bottom: 0, right: 0)
//        }
//    }
    
}
