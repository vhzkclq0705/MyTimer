//
//  AddSectionViewController.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/31.
//

import UIKit
import RxSwift
import RxCocoa

/// ViewController for adding sections
final class AddSectionViewController: BaseViewController {
    
    // MARK: Properties
    
    private let viewModel: AddSectionViewModel
    private let addSectionView = AddSectionView()
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    
    init(viewModel: AddSectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life cycle
    
    override func loadView() {
        super.loadView()
        view = addSectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Configure
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func configureViewController() {
        setupBindings()
    }
    
    private func setupBindings() {
        let input = AddSectionViewModel.Input(
            title: addSectionView.textField.rx.text.orEmpty.distinctUntilChanged().asObservable(),
            okButtonTapEvent: addSectionView.okButton.rx.tap.asObservable(),
            cancelButtonTapEvent: addSectionView.cancleButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.isTitleLengthExceeded
            .drive(with: self, onNext: { owner, isExceeded in
                // 경고 + 입력불가
            })
            .disposed(by: disposeBag)
        
        output.createSection
            .emit(with: self, onNext: { owner, _ in
                self.createSections()
            })
            .disposed(by: disposeBag)
        
        output.dismissViewController
            .emit(with: self, onNext: { owner, _ in
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
            
    }

//    func setController() {
//        addSectionView.textField.delegate = self
//        
//        addSectionView.okButton.addTarget(
//            self,
//            action: #selector(okButtonTapped(_:)),
//            for: .touchUpInside)
//        addSectionView.cancleButton.addTarget(
//            self,
//            action: #selector(didTapCancleButton(_:)),
//            for: .touchUpInside)
//    }
    
    // MARK: Actions
    
    private func createSections() {
        viewModel.createSections()
        
    }
    
//    @objc func okButtonTapped(_ sender: UIButton) {
//        guard let term = addSectionView.textField.text,
//              term != "섹션 이름을 입력해주세요",
//              term.isEmpty == false else {
//            addSectionView.textField.text = "섹션 이름을 입력해주세요"
//            addSectionView.textField.textColor = UIColor.CustomColor(.gray1)
//            addSectionView.textField.layer.borderColor = UIColor.CustomColor(.red).cgColor
//            addSectionView.alertLabel.alpha = 1
//            return
//        }
//        
//        TimerManager.shared.addSection(term)
//        
//        changeCompleteView(.addSection)
//    }
}

//// MARK: - TextView
//extension AddSectionViewController: UITextViewDelegate {
//    // Limit TextField range
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        textView.text = ""
//        textView.textColor = .black
//    }
//    
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text == "" {
//            textView.text = "섹션 이름을 입력해주세요"
//            textView.textColor = UIColor.CustomColor(.gray1)
//        } else {
//            textView.layer.borderColor = UIColor.CustomColor(.gray1).cgColor
//            addSectionView.alertLabel.alpha = 0
//        }
//    }
//    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange,
//        replacementText text: String) -> Bool {
//        guard let term = addSectionView.textField.text,
//              let stringRange = Range(range, in: term) else {
//            return false
//        }
//        let updatedText = term.replacingCharacters(
//            in: stringRange,
//            with: text)
//        
//        return updatedText.count <= 10
//    }
//}
