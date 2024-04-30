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
import RxGesture

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
        setupTextView()
        setupDropDown()
        view.backgroundColor = .black.withAlphaComponent(0.5)
    }
    
    private func setupBindings() {
        let input = AddTimerViewModel.Input(
            title: addTimerView.timerTextField.rx.text.orEmpty.distinctUntilChanged().asObservable(),
            minSelectEvent: addTimerView.minPickerView.rx.itemSelected.asObservable(),
            secSelectEvent: addTimerView.secPickerView.rx.itemSelected.asObservable(),
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
            .emit(with: self, onNext: { owner, isValidated in
                owner.createTimers(isValidated)
            })
            .disposed(by: disposeBag)
        
        output.dismissViewController
            .emit(with: self, onNext: { owner, _ in
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTextView() {
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
        
        dropDown.dataSource = viewModel.getTitles()
        dropDown.dismissMode = .automatic
        dropDown.anchorView = addTimerView.sectionView
        dropDown.bottomOffset = CGPoint(x: 0, y: 51)
        dropDown.selectionAction = { [weak self] index, item in
            self?.viewModel.updateSelectedSection(newValue: index)
            self?.addTimerView.updateViewsAfterSelecting(item)
        }
        dropDown.cancelAction = { [weak self] in
            self?.addTimerView.rotateArrowImage()
        }
        
        addTimerView.sectionView.rx.tapGesture().when(.recognized)
            .subscribe(with: self, onNext: { owner, _ in
                owner.dropDown.show()
                owner.addTimerView.rotateArrowImage()
            })
            .disposed(by: disposeBag)
    }
    
    
    // MARK: Create Timers
    
    private func createTimers(_ isValidated: (Bool, Bool)) {
        if isValidated.0 && isValidated.1 {
            viewModel.createTimers()
            dismiss(animated: true)
        } else {
            if !isValidated.0 { addTimerView.displaySectionAlarm() }
            if !isValidated.1 { addTimerView.displayTimerAlarm() }
        }
    }
    
    // MARK: Helper Methods
    
    private func createCustomView(_ text: String) -> UILabel {
        return UILabel().then {
            $0.setLabelStyle(text: text, font: .bold, size: 30, color: .CustomColor(.purple4))
            $0.textAlignment = .center
        }
    }
    
}
