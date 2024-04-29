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
    private let updateSectionView = AddORSetSectionView(frame: .zero, feature: .Update)
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
        view.backgroundColor = .black.withAlphaComponent(0.5)
    }
    
    private func setupBindings() {
        let input = UpdateSectionViewModel.Input(
            title: updateSectionView.textField.rx.text.orEmpty.distinctUntilChanged().asObservable(),
            okButtonTapEvent: updateSectionView.okButton.rx.tap.asObservable(),
            calcelButtonTapEvent: updateSectionView.cancleButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.titleLength
            .drive(with: self, onNext: { owner, length in
                owner.updateSectionView.validateText(length)
            })
            .disposed(by: disposeBag)
        
        output.updateSection
            .emit(with: self, onNext: { owner, _ in
                owner.viewModel.updateSections()
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.dismissViewController
            .emit(with: self, onNext: { owner, _ in
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        updateSectionView.deleteButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.viewModel.deleteSections()
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
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
    
}
