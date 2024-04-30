//
//  AddTimerViewController.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/31.
//

import UIKit
import DropDown
import RxSwift
import RxCocoa

// ViewController for adding timers
final class AddTimerViewController: BaseViewController {
    
    // MARK: Properties
    
    private let addTimerView = AddORSetTimerView(frame: .zero, feature: .Add)
    private let viewModel: AddTimerViewModel
    private let dropDown = DropDown()
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    
    init(viewModel: AddTimerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life cycle
    
    override func loadView() {
        view = addTimerView
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
        setupDropDown()
        view.backgroundColor = .black.withAlphaComponent(0.5)
    }
    
    private func setupBindings() {
        let input = AddTimerViewModel.Input(
            title: addTimerView.timerTextField.rx.text.orEmpty.distinctUntilChanged().asObservable(),
            okButtonTapEvent: addTimerView.okButton.rx.tap.asObservable(),
            cancelButtonTapEvent: addTimerView.cancleButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)

        output.minutes
            .bind(to: addTimerView.minPickerView.rx.items) { [weak self] _, item, view in
                return self?.createCustomView(item) ?? UIView()
            }
            .disposed(by: disposeBag)
        
        output.seconds
            .bind(to: addTimerView.secPickerView.rx.items) { [weak self] _, item, view in
                return self?.createCustomView(item) ?? UIView()
            }
            .disposed(by: disposeBag)
        
        output.titleLength
            .drive(with: self, onNext: { owner, length in
                owner.addTimerView.validateText(length)
            })
            .disposed(by: disposeBag)
        
        output.createTimer
            .emit(with: self, onNext: { owner, _ in
                owner.viewModel.createTimers()
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.dismissViewController
            .emit(with: self, onNext: { owner, _ in
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        addTimerView.timerTextField.rx.didBeginEditing
            .subscribe(with: self, onNext: { owner, _ in
                owner.addTimerView.startEditingTextView()
            })
            .disposed(by: disposeBag)
        
        addTimerView.timerTextField.rx.didEndEditing
            .subscribe(with: self, onNext: { owner, _ in
                owner.addTimerView.endEditingTextView()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupDropDown() {
        let dropDownAppearance = DropDown.appearance()
        dropDownAppearance.textColor = .darkGray
        dropDownAppearance.selectedTextColor = .black
        dropDownAppearance.backgroundColor = .white
        dropDownAppearance.selectionBackgroundColor = .lightGray
        dropDownAppearance.setupCornerRadius(5)
        
        dropDown.dismissMode = .automatic
//        dropDown.dataSource = viewModel.sections
        dropDown.anchorView = addTimerView.sectionView
        dropDown.bottomOffset = CGPoint(x: 0, y: 51)
//        dropDown.selectionAction = { index, item in
////            self.viewModel.section = index
//            self.addTimerView.sectionTextField.text = item
//            self.addTimerView.sectionTextField.textColor = .black
//            self.addTimerView.sectionTextField.layer.borderColor = UIColor.CustomColor(.gray1).cgColor
//            self.addTimerView.alertSectionLabel.alpha = 0
//            self.addTimerView.sectionButton.isSelected = false
//        }
//        dropDown.cancelAction = {
//            self.addTimerView.sectionButton.isSelected = false
//        }
    }
    
    // MARK: Helper Methods
    
    private func createCustomView(_ text: String) -> UILabel {
        return UILabel().then {
            $0.setLabelStyle(text: text, font: .bold, size: 30, color: .CustomColor(.purple4))
            $0.textAlignment = .center
        }
    }
    
}
