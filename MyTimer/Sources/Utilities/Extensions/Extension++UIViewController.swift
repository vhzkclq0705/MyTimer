//
//  Extension++UIViewController.swift
//  MyTimer
//
//  Created by 권오준 on 2022/07/06.
//

import UIKit

enum Configure: String {
    case addSection = "섹션이 추가되었습니다."
    case deleteSection = "섹션이 삭제되었습니다."
    case setSection = "섹션이 수정되었습니다."
    case addTimer = "타이머가 추가되었습니다."
    case deleteTimer = "타이머가 삭제되었습니다."
    case setTimer = "타이머가 수정되었습니다."
    case settings = "설정이 저장되었습니다."
}

extension UIViewController{
    func changeCompleteView(_ type: Configure) {
        let completeView = CompleteView()
        
        completeView.titleLabel.text = type.rawValue
        
        type == .deleteTimer || type == .deleteSection
        ? completeView.okButton.addTarget(
            self,
            action: #selector(dismissAll(_:)),
            for: .touchUpInside)
        : completeView.okButton.addTarget(
            self,
            action: #selector(didTapCancleButton(_:)),
            for: .touchUpInside)
        
        view = completeView
    }
    
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
    
    @objc func didTapCancleButton(_ sender: UIButton) {
        notifyReloadAndDismiss()
    }
    
    @objc func dismissAll(_ sender: UIButton) {
//        let vc = TimerListViewController()
//        view.window?.rootViewController = vc
//        view.window?.rootViewController?.dismiss(animated: false)
    }

}
