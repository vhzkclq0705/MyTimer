//
//  BaseView.swift
//  MyTimer
//
//  Created by 권오준 on 2024-04-25.
//

import UIKit

/// View contains basic methods and properties.
class BaseView: UIView {
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure
    
    func configureView() {
        backgroundColor = .white
    }
    
    func configureUI() {}
    
    func configureLayout() {}
    
}
