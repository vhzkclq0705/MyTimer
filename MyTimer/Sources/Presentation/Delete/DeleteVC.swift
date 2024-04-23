//
//  DeleteVC.swift
//  MyTimer
//
//  Created by 권오준 on 2022/07/11.
//

import UIKit
import SnapKit

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

class DeleteVC: UIViewController {
    
    // MARK: - Property
    let checkView = CheckView()
    var type: Check!
    var sectionTitle: String!
    var section: Section!
    var timer: MyTimer!
    
    // MARK: - Life cycle
    override func loadView() {
        setLabelLayout()
        view = checkView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setController()
    }
    
    // MARK: - Setup
    func setController() {
        checkView.titleLabel.text = type.title
        checkView.subTitleLabel.text = type.subTitle
        
        checkView.cancleButton.addTarget(
            self,
            action: #selector(didTapCancleButton(_:)),
            for: .touchUpInside)
        checkView.okButton.addTarget(
            self,
            action: #selector(didTapOkButton(_:)),
            for: .touchUpInside)
    }
    
    func setLabelLayout() {
        type == .section
        ? checkView.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(41)
            $0.centerX.equalToSuperview()
        }
        : checkView.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(53)
            $0.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    func deleteTimer(sectionTitle: String, timer: MyTimer) {
        TimerManager.shared.deleteTimer(
            sectionTitle: sectionTitle,
            timer: timer)
    }
    
    func deleteSection(_ section: Section) {
        TimerManager.shared.deleteSection(section)
    }
    
    @objc func didTapOkButton(_ sender: UIButton) {
        if type == .section {
            deleteSection(section)
            changeCompleteView(.deleteSection)
        } else {
            deleteTimer(sectionTitle: sectionTitle, timer: timer)
            changeCompleteView(.deleteTimer)
        }
    }
}
