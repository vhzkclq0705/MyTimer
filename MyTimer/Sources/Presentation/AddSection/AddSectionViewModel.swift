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
        let titleLength: Driver<Int>
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
                print(owner.title)
            })
            .disposed(by: disposeBag)
        
        let titleLength = inputTitle
            .map { $0.count }
            .asDriver(onErrorJustReturn: 0)
        
        let createSection = input.okButtonTapEvent
            .asSignal(onErrorJustReturn: ())
        
        let dismissViewController = input.cancelButtonTapEvent
            .asSignal(onErrorJustReturn: ())
        
        return Output(
            titleLength: titleLength,
            createSection: createSection,
            dismissViewController: dismissViewController)
    }
    
    // MARK: Create sections
    
    func createSections() {
        RxTimerManager.shared.addSection(title: title)
    }
    
}
