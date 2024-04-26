//
//  CompleteView.swift
//  MyTimer
//
//  Created by 권오준 on 2022/07/11.
//

import UIKit
import SnapKit

class CompleteView: UIView {
    
    // MARK: - UI
    let backgroundView: UIView = {
        let view = UIView()
//        view.setBackgroundView()
        
        return view
    }()
    
    let subView: UIView = {
        let view = UIView()
        view.setupSubView()
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: "",
            font: .bold,
            size: 18,
            color: .black)
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var okButton: UIButton = {
        let button = UIButton()
        button.setSubViewOKButton()
        
        return button
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setLayout()
    }
    
    // MARK: - Setup
    func addViews() {
        [titleLabel, okButton]
            .forEach { subView.addSubview($0) }
        
        [backgroundView, subView]
            .forEach { addSubview($0) }
    }
    
    func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        subView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.right.equalToSuperview().inset(17)
            $0.height.equalTo(180)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(53)
            $0.left.right.equalToSuperview().inset(20)
        }
        
        okButton.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.height.equalTo(59)
        }
    }
}
