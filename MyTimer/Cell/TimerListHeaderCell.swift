//
//  TimerListHeaderCell.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/30.
//

import UIKit
import SnapKit
import ExpyTableView

// Header Cell for TableView
class TimerListHeaderCell: UITableViewCell, ExpyTableViewHeaderCell {
    
    static let id = "timerListHeaderCell"
    
    // MARK: - UI
    let titleLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: "",
            font: .semibold,
            size: 17,
            color: .black)
        
        return label
    }()
    
    lazy var detailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "arrowDown")
        
        return imageView
    }()
    
    lazy var modifyButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "modify"), for: .normal)
        button.addTarget(
            self,
            action: #selector(didTapModifyButton(_:)),
            for: .touchUpInside)
        
        return button
    }()
    
    let clearView = UIButton()
    
    // MARK: - Property
    var color: UIColor!
    
    // MARK: - Button tap handler
    var modifyButtonTapHandler: (() -> Void)?
    
    // MARK: - Cell init
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    // MARK: - Update UI
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
    
    // MARK: - Actions
    @objc func didTapModifyButton(_ sender: UIButton) {
        modifyButtonTapHandler?()
    }
}

extension TimerListHeaderCell {
    // MARK: - Setup
    func setup() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        [
            titleLabel,
            detailImageView,
            modifyButton,
            clearView,
        ]
            .forEach { contentView.addSubview($0) }
        
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
}
