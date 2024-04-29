//
//  SetSectionViewModel.swift
//  MyTimer
//
//  Created by 권오준 on 2024-04-29.
//

import Foundation
import RxSwift
import RxCocoa

/// ViewModel for SetSectionViewController
final class SetSectionViewModel: ViewModelType {
    
    // Properties
    
    struct Input {
        let title: Observable<String>
        let okButtonTapEvent: Observable<Void>
        let calcelButtonTapEvent: Observable<Void>
    }
    
    struct Output {
        let titleLength: Driver<Int>
        let updateSection: Signal<Void>
        let dismissViewController: Signal<Void>
    }
    
    var disposeBag = DisposeBag()
    private var id: UUID
    private var title = ""
    
    // MARK: Init
    
    init(id: UUID) {
        self.id = id
    }
    
    // MARK: Binding
    
    func transform(input: Input) -> Output {
        let inputTitle = input.title.share(replay: 1, scope: .whileConnected)
        
        inputTitle
            .subscribe(with: self, onNext: { owner, title in
                owner.title = title
            })
            .disposed(by: disposeBag)
        
        let titleLength = inputTitle
            .map { $0.count }
            .asDriver(onErrorJustReturn: 0)
        
        let updateSection = input.okButtonTapEvent
            .asSignal(onErrorJustReturn: ())
        
        let dismissViewController = input.calcelButtonTapEvent
            .asSignal(onErrorJustReturn: ())
        
        return Output(
            titleLength: titleLength,
            updateSection: updateSection,
            dismissViewController: dismissViewController)
    }
    
    // MARK: Update sections
    
    func updateSections() {
        RxTimerManager.shared.updateSection(id: id, title: title)
    }
    
}
