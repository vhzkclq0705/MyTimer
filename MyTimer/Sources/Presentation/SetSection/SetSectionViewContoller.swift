//
//  SetSectionViewContoller.swift
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
final class SetSectionViewContoller: BaseViewController {
    
    // MARK: Properties
    
    private let viewModel: SetSectionViewModel
    private let setSectionView = AddSectionView()
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    
    init(viewModel: SetSectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:  Life cycle
    
    override func loadView() {
        view = setSectionView
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
    
    override func configureUI() {
        setSectionView.titleLabel.text = "섹션 이름 변경"
        
        let deleteButton = UIButton().then {
            $0.setImage(UIImage(named: "delete"), for: .normal)
        }
        view.addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.top.right.equalTo(view).inset(15)
        }
        
        
        deleteButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.viewModel.deleteSections()
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupBindings() {
        let input = SetSectionViewModel.Input(
            title: setSectionView.textField.rx.text.orEmpty.distinctUntilChanged().asObservable(),
            okButtonTapEvent: setSectionView.okButton.rx.tap.asObservable(),
            calcelButtonTapEvent: setSectionView.cancleButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.titleLength
            .drive(with: self, onNext: { owner, length in
                owner.setSectionView.validateText(length)
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
        
        setSectionView.textField.rx.didBeginEditing
            .subscribe(with: self, onNext: { owner, _ in
                owner.setSectionView.startEditingTextView()
            })
            .disposed(by: disposeBag)
        
        setSectionView.textField.rx.didEndEditing
            .subscribe(with: self, onNext: { owner, _ in
                owner.setSectionView.endEditingTextView()
            })
            .disposed(by: disposeBag)
    }
    
}
