//
//  UpdateTimerViewController.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/31.
//

import UIKit
import DropDown
import RxSwift
import RxCocoa
import RxGesture

// ViewController for creating or updating timers
final class UpdateTimerViewController: BaseViewController {
    
    // MARK: Properties
    
    private let updateTimerView = UpdateTimerView()
    private let viewModel: UpdateTimerViewModel
    private let dropDown = DropDown()
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    
    init(viewModel: UpdateTimerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life cycle
    
    override func loadView() {
        view = updateTimerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTimerView.hidePickerViewSelectedViews()
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
        let input = UpdateTimerViewModel.Input(
            title: updateTimerView.timerTextField.rx.text.orEmpty.distinctUntilChanged().asObservable(),
            minSelectEvent: updateTimerView.minPickerView.rx.itemSelected.asObservable(),
            secSelectEvent: updateTimerView.secPickerView.rx.itemSelected.asObservable(),
            okButtonTapEvent: updateTimerView.okButton.rx.tap.asObservable(),
            cancelButtonTapEvent: updateTimerView.cancleButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.minutes
            .drive(updateTimerView.minPickerView.rx.items) { [weak self] _, item, view in
                return self?.createCustomViewsOfPickerView(item) ?? UIView()
            }
            .disposed(by: disposeBag)
        
        output.seconds
            .drive(updateTimerView.secPickerView.rx.items) { [weak self] _, item, view in
                return self?.createCustomViewsOfPickerView(item) ?? UIView()
            }
            .disposed(by: disposeBag)
        
        output.initalMinute
            .subscribe(with: self, onNext: { owner, min in
                owner.initPickerViewRows(isMinute: true, row: min)
            })
            .disposed(by: disposeBag)
        
        output.initalSecond
            .subscribe(with: self, onNext: { owner, sec in
                owner.initPickerViewRows(isMinute: false, row: sec)
            })
            .disposed(by: disposeBag)
        
        output.titleLength
            .drive(with: self, onNext: { owner, length in
                owner.validateTextLength(length)
            })
            .disposed(by: disposeBag)
        
        output.createTimer
            .emit(with: self, onNext: { owner, isValidated in
                owner.validateUpdatingTimers(isValidated)
            })
            .disposed(by: disposeBag)
        
        output.dismissViewController
            .emit(with: self, onNext: { owner, _ in
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        setupTextViewBindins()
    }
    
    private func setupTextViewBindins() {
        updateTimerView.timerTextField.rx.didBeginEditing
            .subscribe(with: self, onNext: { owner, _ in
                owner.updateTimerView.startEditingTextView()
            })
            .disposed(by: disposeBag)
        
        updateTimerView.timerTextField.rx.didEndEditing
            .subscribe(with: self, onNext: { owner, _ in
                owner.updateTimerView.endEditingTextView()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupDropDown() {
        DropDown.appearance().backgroundColor = .white
        dropDown.dataSource = viewModel.getTitles()
        dropDown.dismissMode = .automatic
        dropDown.anchorView = updateTimerView.sectionView
        dropDown.bottomOffset = CGPoint(x: 0, y: 51)
        dropDown.selectionAction = { [weak self] index, item in
            self?.didSelectSection(index: index, item: item)
        }
        dropDown.cancelAction = { [weak self] in
            self?.didCancelDropDown()
        }
        dropDown.selectRow(viewModel.getSelectedSectionIndex())
        
        updateTimerView.sectionView.rx.tapGesture().when(.recognized)
            .subscribe(with: self, onNext: { owner, _ in
                owner.didTapSectionView()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Helper Methods
    
    // MARK: Validate
    
    private func validateTextLength(_ length: Int) {
        updateTimerView.validateText(length)
    }
    
    private func validateUpdatingTimers(_ isValidated: (Bool, Bool)) {
        if isValidated.0 && isValidated.1 {
            dismiss(animated: true)
        } else {
            if !isValidated.0 { updateTimerView.displaySectionAlarm() }
            if !isValidated.1 { updateTimerView.displayTimerAlarm() }
        }
    }
    
    // MARK: DropDown
    
    private func didSelectSection(index: Int, item: String) {
        print("select")
        viewModel.updateSelectedSection(newValue: index)
        updateTimerView.updateViewsAfterSelecting(item)
    }
    
    private func didTapSectionView() {
        dropDown.show()
        updateTimerView.rotateArrowImage()
    }
    
    private func didCancelDropDown() {
        print("cancel")
        updateTimerView.rotateArrowImage()
    }
    
    // MARK: Others
    
    private func initPickerViewRows(isMinute: Bool, row: Int) {
        updateTimerView.initPickerViewRows(isMinute: isMinute, row)
    }
    
    private func createCustomViewsOfPickerView(_ text: String) -> UILabel {
        return UILabel().then {
            $0.setLabelStyle(text: text, font: .bold, size: 30, color: .CustomColor(.purple4))
            $0.textAlignment = .center
        }
    }
    
}
