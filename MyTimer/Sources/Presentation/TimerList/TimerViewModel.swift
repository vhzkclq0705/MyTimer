//
//  TimerViewModel.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/30.
//

import Foundation
import RxSwift
import RxCocoa

/// ViewModel for TimerListViewController
final class TimerViewModel: ViewModelType {
    
    // MARK: Properties
    
    struct Input {
        let menuButtonTapEvent: Observable<Void>
        let addSectionButtonTapEvent: Observable<Void>
        let addTimerButtonTapEvent: Observable<Void>
        let settingsButtonTapEvent: Observable<Void>
        let gestureTapEvent: Observable<Void>
    }
    
    struct Output {
        let sections: Driver<[RxSection]>
        let showButtons: Signal<Void>
        let hideButtons: Signal<Void>
        let presentAddSectionViewController: Signal<Void>
        let presentAddTimerViewController: Signal<Void>
        let presentSettingsViewController: Signal<Void>
    }
    
    var disposeBag = DisposeBag()
    
    // MARK: Init
    
    init() {}
    
    // MARK: Binding
    
    func transform(input: Input) -> Output {
        let sections = RxTimerManager.shared.getData()
        
        let showButtons = input.menuButtonTapEvent
            .asSignal(onErrorJustReturn: ())
        
        let hideButtons = input.gestureTapEvent
            .asSignal(onErrorJustReturn: ())
        
        let presentAddSectionViewController = input.addSectionButtonTapEvent
            .asSignal(onErrorJustReturn: ())
        
        let presentAddTimerViewController = input.addTimerButtonTapEvent
            .asSignal(onErrorJustReturn: ())
        
        let presentSettingsViewController = input.settingsButtonTapEvent
            .asSignal(onErrorJustReturn: ())
        
        return Output(
            sections: sections,
            showButtons: showButtons,
            hideButtons: hideButtons,
            presentAddSectionViewController: presentAddSectionViewController,
            presentAddTimerViewController: presentAddTimerViewController,
            presentSettingsViewController: presentSettingsViewController)
    }
    
}
