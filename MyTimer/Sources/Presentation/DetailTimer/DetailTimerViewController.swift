//
//  DetailTimerViewController.swift
//  MyTimer
//
//  Created by 권오준 on 2022/06/02.
//

import UIKit
import RxSwift
import RxCocoa

/// ViewController for timers
final class DetailTimerViewController: BaseViewController {
    
    // MARK: Properties
    
    private let viewModel: DetailTimerViewModel
    private let detailTimerView = DetailTimerView()
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    
    init(viewModel: DetailTimerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life cycle
    
    override func loadView() {
        view = detailTimerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        detailTimerView.setupProgressingLayers()
    }
    
    // MARK: Configure
    
    override func configureViewController() {
        setupBindings()
    }
    
    private func setupBindings() {
        let input = DetailTimerViewModel.Input(
            resetButtonTapEvent: detailTimerView.resetButton.rx.tap.asObservable(),
            timerStateButtonTapEvent: detailTimerView.timerStateButton.rx.tap.asObservable(),
            backButtonTapEvent: detailTimerView.backButton.rx.tap.asObservable(),
            settingsButtonTapEvent: detailTimerView.settingButton.rx.tap.asObservable(),
            deleteButtonTapEvent: detailTimerView.deleteButton.rx.tap.asObservable(),
            bellButtonTapEvent: detailTimerView.bellButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.titles
            .drive(with: self, onNext: { owner, title in
                owner.updateTitles(title: title)
            })
            .disposed(by: disposeBag)
        
        output.initTime
            .drive(with: self, onNext: { owner, time in
                owner.setupProgressingAnimation(duration: time)
            })
            .disposed(by: disposeBag)
        
        output.remainingTimeText
            .drive(with: self, onNext: { owner, time in
                owner.updateRemainingTime(time: time)
            })
            .disposed(by: disposeBag)
        
        output.sendNotification
            .emit(with: self, onNext: { owner, _ in
                owner.updateAlertView()
            })
            .disposed(by: disposeBag)
        
        output.removeAlarm
            .emit(with: self, onNext: { owner, _ in
                owner.removeAlarm()
            })
            .disposed(by: disposeBag)
        
        output.resetTimer
            .emit(with: self, onNext: { owner, _ in
                owner.changeProgressingState(state: .reset)
            })
            .disposed(by: disposeBag)
        
        output.changeTimerState
            .emit(with: self, onNext: { owner, _ in
                owner.changeProgressingState(state: .start)
            })
            .disposed(by: disposeBag)
        
        output.presentSettingsViewController
            .emit(with: self, onNext: { owner, _ in
                owner.presentUpdateTimerViewController()
            })
            .disposed(by: disposeBag)
        
        output.deleteTimer
            .emit(with: self, onNext: { owner, _ in
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.dismissViewController
            .emit(with: self, onNext: { owner, _ in
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Helper Methods
    
    private func updateTitles(title: (String, String)) {
        detailTimerView.updateTitles(title: title)
    }
    
    private func updateRemainingTime(time: String) {
        detailTimerView.updateRemainingTime(time: time)
    }
    
    private func setupProgressingAnimation(duration: Double) {
        detailTimerView.setupProgressingAnimation(duration: duration)
    }
    
    private func updateAlertView() {
        detailTimerView.updateNotificationView(show: true)
    }
    
    private func removeAlarm() {
        changeProgressingState(state: .reset)
        detailTimerView.removeNotificationView()
    }
    
    private func changeProgressingState(state: ProgressingState) {
        detailTimerView.changeProgressingState(state: state)
    }
    
    private func presentUpdateTimerViewController() {
        let data = viewModel.getData()
        let viewModel = UpdateTimerViewModel(sectionID: data.0, myTimer: data.1)
        let vc = UpdateTimerViewController(viewModel: viewModel)
        
        presentCustom(vc)
    }

}
