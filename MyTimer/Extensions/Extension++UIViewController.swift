//
//  Extension++UIViewController.swift
//  MyTimer
//
//  Created by 권오준 on 2022/07/06.
//

import UIKit

extension UIViewController{
    func presentCustom(_ vc: UIViewController) {
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        
        present(vc, animated: true)
    }
    
    func notifyReloadAndDismiss() {
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: "reload"),
            object: nil,
            userInfo: nil)
        
        dismiss(animated: true)
    }
}
