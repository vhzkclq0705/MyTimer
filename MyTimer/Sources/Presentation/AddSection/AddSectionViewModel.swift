//
//  AddSectionViewModel.swift
//  MyTimer
//
//  Created by 권오준 on 2024-04-26.
//

import Foundation
import RxSwift
import RxCocoa

/// ViewModel for AddSectionViewController
final class AddSectionViewModel: ViewModelType {
    
    // MARK: Properties
    
    struct Input {
        let title: Observable<String>
        let okButtonTapEvent: Observable<Void>
        let cancelButtonTapEvent: Observable<Void>
    }
    
    struct Output {
        let isTitleLengthExceeded: Driver<Bool>
        let createSection: Signal<Void>
        let dismissViewController: Signal<Void>
    }
    
    var disposeBag = DisposeBag()
    private var title = ""
    private let maxLength = 10
    
    // MARK: Init
    
    init() {}
    
    // MARK: Binding
    
    func transform(input: Input) -> Output {
        let inputTitle = input.title.share(replay: 1, scope: .whileConnected)
        
        inputTitle
            .subscribe(with: self, onNext: { owner, title in
                owner.title = title
            })
            .disposed(by: disposeBag)
        
        let isTitleLengthExceeded = inputTitle
            .map { [weak self] in $0.count > (self?.maxLength ?? 0) }
            .asDriver(onErrorJustReturn: false)
        
        let createSection = input.okButtonTapEvent
            .asSignal(onErrorJustReturn: ())
        
        let dismissViewController = input.cancelButtonTapEvent
            .asSignal(onErrorJustReturn: ())
        
        return Output(
            isTitleLengthExceeded: isTitleLengthExceeded,
            createSection: createSection,
            dismissViewController: dismissViewController)
    }
    
    // MARK: Create sections
    
    func createSections() {
        RxTimerManager.shared.addSection(title: title)
    }
    
}
