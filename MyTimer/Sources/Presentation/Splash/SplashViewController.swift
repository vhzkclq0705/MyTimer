//
//  SplashVC.swift
//  MyTimer
//
//  Created by 권오준 on 2022/07/06.
//

import UIKit
import SnapKit
import Then

/// Displays the splash screen when the app launches
final class SplashViewController: UIViewController {
    
    // MARK: UI

    private lazy var splashLogo = UIImageView().then {
        $0.image = UIImage(named: "splash")
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(splashLogo)
        setLayout()
    }
    
    // MARK: Configure
    
    private func configureViewController() {
        view.backgroundColor = .white
    }
    
    private func addUI() {
        view.addSubview(splashLogo)
    }
    
    private func configureLayout() {
        
    }
    
    func setLayout() {
        splashLogo.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(100)
        }
    }
}
