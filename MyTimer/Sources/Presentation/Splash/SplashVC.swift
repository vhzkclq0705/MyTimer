//
//  SplashVC.swift
//  MyTimer
//
//  Created by 권오준 on 2022/07/06.
//

import UIKit
import SnapKit

class SplashVC: UIViewController {

    let splashLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "splash")
        
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(splashLogo)
        setLayout()
    }
    
    func setLayout() {
        splashLogo.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(100)
        }
    }
}
