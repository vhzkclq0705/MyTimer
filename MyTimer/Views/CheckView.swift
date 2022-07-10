//
//  CheckView.swift
//  MyTimer
//
//  Created by 권오준 on 2022/07/11.
//

import UIKit
import SnapKit

class CheckView: UIView {
    // MARK: - UI
    let backgroundView: UIView = {
        let view = UIView()
        view.setBackgroundView()
        
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
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(
            text: "",
            font: .semibold,
            size: 15,
            color: UIColor.CustomColor(.red))
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var okButton: UIButton = {
        let button = UIButton()
        button.setSubViewOKButton()
        
        return button
    }()
    
    lazy var cancleButton: UIButton = {
        let button = UIButton()
        button.setSubViewCancleButton()
        
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
        [titleLabel, subTitleLabel, okButton, cancleButton]
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
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.left.right.equalTo(titleLabel)
        }
        
        okButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.equalTo(subView.snp.centerX)
            $0.right.equalToSuperview()
            $0.height.equalTo(59)
        }
        
        cancleButton.snp.makeConstraints {
            $0.top.equalTo(okButton)
            $0.left.equalToSuperview()
            $0.right.equalTo(subView.snp.centerX)
            $0.height.equalTo(59)
        }
    }
}
