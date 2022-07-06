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
    
    lazy var detailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "arrowDown")
        
        return imageView
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
            detailImageView,
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
}
