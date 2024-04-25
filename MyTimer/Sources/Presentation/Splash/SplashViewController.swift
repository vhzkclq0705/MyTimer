//
//  SplashViewController.swift
//  MyTimer
//
//  Created by 권오준 on 2022/07/06.
//

import UIKit
import SnapKit
import Then

/// Class for Displaying the splash screen when the app launches
final class SplashViewController: BaseViewController {
    
    // MARK: UI

    private lazy var splashLogo = UIImageView().then {
        $0.image = UIImage(named: "splash")
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Configure
    
    override func configureUI() {
        view.addSubview(splashLogo)
    }
    
    override func configureLayout() {
        splashLogo.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(100)
        }
    }

}
