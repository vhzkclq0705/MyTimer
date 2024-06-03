//
//  UpdateSectionViewContoller.swift
//  MyTimer
//
//  Created by 권오준 on 2022/07/11.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

/// ViewController for updating sections
final class UpdateSectionViewContoller: BaseViewController {
    
    // MARK: Properties
    
    private let viewModel: UpdateSectionViewModel
    private let updateSectionView = UpdateSectionView()
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    
    init(viewModel: UpdateSectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:  Life cycle
    
    override func loadView() {
        view = updateSectionView
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
        setupTextViewBindings()
    }
    
    // MARK: Binding
    
    private func setupBindings() {
        let input = UpdateSectionViewModel.Input(
            title: updateSectionView.textField.rx.text.orEmpty.distinctUntilChanged().asObservable(),
            deleteButtonTapEvent: updateSectionView.deleteButton.rx.tap.asObservable(),
            okButtonTapEvent: updateSectionView.okButton.rx.tap.asObservable(),
            cancelButtonTapEvent: updateSectionView.cancleButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.isTypeCreate
            .drive(with: self, onNext: { owner, isTypeCreate in
                owner.updateUI(isTypeCreate: isTypeCreate)
            })
            .disposed(by: disposeBag)
        
        output.titleLength
            .drive(with: self, onNext: { owner, length in
                owner.validateText(length: length)
            })
            .disposed(by: disposeBag)
        
        output.dismissViewController
            .emit(with: self, onNext: { owner, _ in
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTextViewBindings() {
        updateSectionView.textField.rx.didBeginEditing
            .subscribe(with: self, onNext: { owner, _ in
                owner.updateSectionView.startEditingTextView()
            })
            .disposed(by: disposeBag)
        
        updateSectionView.textField.rx.didEndEditing
            .subscribe(with: self, onNext: { owner, _ in
                owner.updateSectionView.endEditingTextView()
            })
            .disposed(by: disposeBag)
    }
 
    // MARK: Helper Methods
    
    private func validateText(length: Int) {
        updateSectionView.validateText(length)
    }
    
    private func updateUI(isTypeCreate: Bool) {
        updateSectionView.updateUI(isTypeCreate)
    }
    
}
