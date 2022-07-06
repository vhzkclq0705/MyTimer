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
    
    // MARK: - Create UI items
    let titleLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: "",
            font: .semibold,
            size: 17,
            color: .black)
        
        return label
    }()
    
    lazy var detailButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setImage(
            UIImage(named: "arrowDown"),
            for: .normal)
        button.setImage(
            UIImage(named: "arrowUp"),
            for: .selected)
        
        return button
    }()
    
    // MARK: - Property
    var color: UIColor!
    
    // MARK: - Cell init
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
}

extension TimerListHeaderCell {
    // MARK: - Setup UI
    func setup() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        [
            titleLabel,
            detailButton,
        ]
            .forEach { contentView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview()
        }
        
        detailButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(titleLabel.snp.right).offset(5)
        }
    }
    
    // MARK: - Update UI
    func updateUI(text: String) {
        titleLabel.text = text
    }
    
    func changeState(_ state: ExpyState, cellReuseStatus cellReuse: Bool) {
        switch state {
        case .willExpand, .willCollapse:
            detailButton.isSelected = !detailButton.isSelected
        default: break
        }
    }
}
