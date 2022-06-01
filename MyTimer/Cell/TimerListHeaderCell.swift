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
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .bold)
        
        return label
    }()
    
    lazy var detailButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.isUserInteractionEnabled = false
        
        var config = UIButton.Configuration.plain()
        config.preferredSymbolConfigurationForImage =  UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        button.configuration = config
        
        return button
    }()
    
    var color: UIColor!
    
    // MARK: - Funcs for life cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
}

// MARK: - Funcs for setup UI
extension TimerListHeaderCell {
    func setup() {
        self.selectionStyle = .none
        
        [titleLabel, detailButton].forEach { contentView.addSubview($0) }

        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(50)
        }
        
        detailButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(10)
        }
    }
    
    // MARK: - Fucs for update UI
    func updateUI(text: String, color: UIColor) {
        titleLabel.text = text
        self.backgroundColor = color
    }
    
    func changeState(_ state: ExpyState, cellReuseStatus cellReuse: Bool) {
        switch state {
        case .willExpand: changeDetailButton(true)
        case .willCollapse: changeDetailButton(false)
        default: break
        }
    }
    
    func changeDetailButton(_ isChanged: Bool) {
        let angle: CGFloat = isChanged ? Double.pi : 0
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.detailButton.transform = CGAffineTransform(rotationAngle: angle)
        }
    }
}
