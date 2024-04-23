//
//  BaseViewController.swift
//  MyTimer
//
//  Created by 권오준 on 2024-04-23.
//

import UIKit

/// Contains basic options to configure ViewController
class BaseViewController: UIViewController {
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureNavigationBar()
        addViews()
        configureLayout()
    }
    
    // MARK: Functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func configureViewController() {
        view.backgroundColor = .white
        
        // override 후, 원하는 작업 추가
    }
    
    func configureNavigationBar() {
        // override 후, 원하는 작업 추가
    }
    
    func addViews() {
        // override 후, UI 컴포넌트들 addSubView
    }
    
    func configureLayout() {
        // override 후, UI 컴포넌트들 레이아웃 추가
    }
    
}
