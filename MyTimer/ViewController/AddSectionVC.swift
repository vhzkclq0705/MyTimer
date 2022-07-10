//
//  AddSectionVC.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/31.
//

import UIKit

// ViewController for add section
class AddSectionVC: UIViewController {
    
    // MARK: - Property
    let addSectionView = AddSectionView()
    
    
    // MARK: - Life cycle
    override func loadView() {
        view = addSectionView
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
        addSectionView.textField.delegate = self
        
        addSectionView.okButton.addTarget(
            self,
            action: #selector(okButtonTapped(_:)),
            for: .touchUpInside)
        addSectionView.cancleButton.addTarget(
            self,
            action: #selector(didTapCancleButton(_:)),
            for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc func reload() {
        dismiss(animated: true)
    }
    
    @objc func okButtonTapped(_ sender: UIButton) {
        guard let term = addSectionView.textField.text,
              term != "섹션 이름을 입력해주세요",
              term.isEmpty == false else {
            addSectionView.textField.text = "섹션 이름을 입력해주세요"
            addSectionView.textField.textColor = UIColor.CustomColor(.gray1)
            addSectionView.textField.layer.borderColor = UIColor.CustomColor(.red).cgColor
            addSectionView.alertLabel.alpha = 1
            return
        }
        
        TimerManager.shared.addSection(term)
        
        changeCompleteView(.addSection)
    }
}

// MARK: - TextView
extension AddSectionVC: UITextViewDelegate {
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
            addSectionView.alertLabel.alpha = 0
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange,
        replacementText text: String) -> Bool {
        guard let term = addSectionView.textField.text,
              let stringRange = Range(range, in: term) else {
            return false
        }
        let updatedText = term.replacingCharacters(
            in: stringRange,
            with: text)
        
        return updatedText.count <= 10
    }
}
