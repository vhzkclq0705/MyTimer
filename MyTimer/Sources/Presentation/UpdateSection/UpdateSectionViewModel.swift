//
//  UpdateSectionViewModel.swift
//  MyTimer
//
//  Created by 권오준 on 2024-04-29.
//

import Foundation
import RxSwift
import RxCocoa

/// ViewModel for UpdateSectionViewController
final class UpdateSectionViewModel: ViewModelType {
    
    // Properties
    
    struct Input {
        let title: Observable<String>
        let deleteButtonTapEvent: Observable<Void>
        let okButtonTapEvent: Observable<Void>
        let cancelButtonTapEvent: Observable<Void>
    }
    
    struct Output {
        let isTypeCreate: Driver<Bool>
        let titleLength: Driver<Int>
        let dismissViewController: Signal<Void>
    }
    
    var disposeBag = DisposeBag()
    private var sectionType: SectionType
    private var id: UUID?
    private var title = ""
    
    // MARK: Init
    
    init(id: UUID? = nil) {
        self.id = id
        self.sectionType = id == nil ? .Create : .Update
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
        
        let deleteSection = handleEvents(input.deleteButtonTapEvent, action: deleteSections)
        
        let completeAction = handleEvents(input.okButtonTapEvent, action: progressOKAction)
        
        let dismissViewController = Observable.merge(
            deleteSection,
            completeAction,
            input.cancelButtonTapEvent
        )
            .asSignal(onErrorJustReturn: ())
        
        return Output(
            isTypeCreate: Driver.just(sectionType == .Create),
            titleLength: titleLength,
            dismissViewController: dismissViewController)
    }
    
    // MARK: - Sections
    
    private func createSections() {
        RxTimerManager.shared.addSection(title: title)
    }
    
    private func updateSections() {
        guard let id = id else { return }
        RxTimerManager.shared.updateSection(id: id, title: title)
    }
    
    private func deleteSections() {
        guard let id = id else { return }
        RxTimerManager.shared.deleteSection(id: id)
    }
    
    // MARK: - Helper Methods
    
    private func progressOKAction() {
        sectionType == .Create
        ? createSections()
        : updateSections()
    }
    
    private func handleEvents(_ event: Observable<Void>, action: @escaping () -> Void) -> Observable<Void> {
        return event
            .do(onNext: {
                action()
            })
    }
    
}
