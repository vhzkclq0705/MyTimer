//
//  TimerListHeaderCell.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/30.
//

import UIKit
import SnapKit
import ExpyTableView

class TimerListHeaderCell: UITableViewCell, ExpyTableViewHeaderCell {
    
    static let id = "timerListHeaderCell"
    
    var color: UIColor!
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
}

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


