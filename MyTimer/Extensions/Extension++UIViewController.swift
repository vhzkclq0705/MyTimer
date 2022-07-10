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

enum Check {
    case section
    case timer
    
    var title: String {
        switch self {
        case .section: return "섹션을 삭제하시겠습니까?"
        case .timer: return "타이머를 삭제하시겠습니까?"
        }
    }
    
    var subTitle: String {
        switch self {
        case .section: return "섹션에 포함된 타이머가 모두 삭제됩니다."
        case .timer: return ""
        }
    }
}

extension UIViewController{
    func changeCompleteView(_ type: Configure) {
        let completeView = CompleteView()
        
        completeView.titleLabel.text = type.rawValue
        type == .deleteTimer
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
    
    func changeCheckView(_ type: Check) -> CheckView {
        let checkView = CheckView()
        
        checkView.titleLabel.text = type.title
        checkView.subTitleLabel.text = type.subTitle
        checkView.cancleButton.addTarget(
            self,
            action: #selector(didTapCancleButton(_:)),
            for: .touchUpInside)
        
        return checkView
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
        let vc = TimerListVC()
        view.window?.rootViewController = vc
        view.window?.rootViewController?.dismiss(animated: false)
    }

}
