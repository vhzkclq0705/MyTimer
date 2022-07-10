//
//  SetSectionVC.swift
//  MyTimer
//
//  Created by 권오준 on 2022/07/11.
//

import UIKit
import SnapKit

class SetSectionVC: UIViewController {
    
    // MARK: - Property
    let setSectionView = AddSectionView()
    var section: Section!
    
    // MARK: - Life cycle
    override func loadView() {
        createDeleteButton()
        view = setSectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setController()
    }
    
    // MARK: - Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Setup
    func setController() {
        setSectionView.titleLabel.text = "섹션 이름 변경"
        setSectionView.textField.delegate = self
        
        setSectionView.okButton.addTarget(
            self,
            action: #selector(okButtonTapped(_:)),
            for: .touchUpInside)
        setSectionView.cancleButton.addTarget(
            self,
            action: #selector(didTapCancleButton(_:)),
            for: .touchUpInside)
    }
    
    func createDeleteButton() {
        lazy var deleteButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(named: "delete"), for: .normal)
            button.addTarget(
                self,
                action: #selector(didTapDeleteButton(_:)),
                for: .touchUpInside)
            
            return button
        }()
        
        setSectionView.subView.addSubview(deleteButton)
        
        deleteButton.snp.makeConstraints {
            $0.top.right.equalToSuperview().inset(15)
        }
    }
    
    // MARK: - Actions
    @objc func reload() {
        dismiss(animated: true)
    }
    
    @objc func didTapDeleteButton(_ sender: UIButton) {
        guard let pvc = self.presentingViewController else { return }
        
        self.dismiss(animated: false) {
            let vc = DeleteVC()
            vc.type = .section
            vc.section = self.section
            
            pvc.presentCustom(vc)
        }
    }
    
    @objc func okButtonTapped(_ sender: UIButton) {
        guard let term = setSectionView.textField.text,
              term != "섹션 이름을 입력해주세요",
              term.isEmpty == false else {
            setSectionView.textField.text = "섹션 이름을 입력해주세요"
            setSectionView.textField.textColor = UIColor.CustomColor(.gray1)
            setSectionView.textField.layer.borderColor = UIColor.CustomColor(.red).cgColor
            setSectionView.alertLabel.alpha = 1
            return
        }
        
        TimerManager.shared.setSection(
            section: section,
            title: term)
        
        changeCompleteView(.setSection)
    }
}

// MARK: - TextView
extension SetSectionVC: UITextViewDelegate {
    // Limit TextField range
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = .black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "섹션 이름을 입력해주세요"
            textView.textColor = UIColor.CustomColor(.gray1)
        } else {
            textView.layer.borderColor = UIColor.CustomColor(.gray1).cgColor
            setSectionView.alertLabel.alpha = 0
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        guard let term = setSectionView.textField.text,
              let stringRange = Range(range, in: term) else {
            return false
        }
        let updatedText = term.replacingCharacters(
            in: stringRange,
            with: text)
        
        return updatedText.count <= 10
    }
}
