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
        view.backgroundColor = .black.withAlphaComponent(0.5)
    }
    
    private func setupBindings() {
        let input = AddSectionViewModel.Input(
            title: addSectionView.textField.rx.text.orEmpty.distinctUntilChanged().asObservable(),
            okButtonTapEvent: addSectionView.okButton.rx.tap.asObservable(),
            cancelButtonTapEvent: addSectionView.cancleButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.titleLength
            .drive(with: self, onNext: { owner, length in
                owner.addSectionView.validateText(length)
            })
            .disposed(by: disposeBag)
        
        output.createSection
            .emit(with: self, onNext: { owner, _ in
                owner.viewModel.createSections()
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.dismissViewController
            .emit(with: self, onNext: { owner, _ in
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        addSectionView.textField.rx.didBeginEditing
            .subscribe(with: self, onNext: { owner, _ in
                owner.addSectionView.startEditingTextView()
            })
            .disposed(by: disposeBag)
        
        addSectionView.textField.rx.didEndEditing
            .subscribe(with: self, onNext: { owner, _ in
                owner.addSectionView.endEditingTextView()
            })
            .disposed(by: disposeBag)
    }
    
}
