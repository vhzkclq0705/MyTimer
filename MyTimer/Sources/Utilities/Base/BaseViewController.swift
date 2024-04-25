//
//  BaseViewController.swift
//  MyTimer
//
//  Created by 권오준 on 2024-04-25.
//

import UIKit

/// ViewController contains basic methods and properties.
class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureNavigationBar()
        configureUI()
        configureLayout()
    }
    
    func configureViewController() {
        view.backgroundColor = .white
    }
    
    func configureNavigationBar() {}
    
    func configureUI() {}
    
    func configureLayout() {}
    
}
