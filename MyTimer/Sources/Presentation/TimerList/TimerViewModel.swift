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
final class TimerListViewModel: ViewModelType {
    
    // MARK: Properties
    
    struct Input {
        let menuButtonTapEvent: Observable<Void>
        let addSectionButtonTapEvent: Observable<Void>
        let addTimerButtonTapEvent: Observable<Void>
        let settingsButtonTapEvent: Observable<Void>
        let controlViewTapEvent: Observable<Void>
    }
    
    struct Output {
        let data: Driver<[CellModel]>
        let showButtons: Signal<Void>
        let presentAddSectionViewController: Signal<Void>
        let presentAddTimerViewController: Signal<Void>
        let presentSettingsViewController: Signal<Void>
    }
    
    var disposeBag = DisposeBag()
    
    // MARK: Init
    
    init() {}
    
    // MARK: Binding
    
    func transform(input: Input) -> Output {
        var dataModel: Driver<[CellModel]> {
            let (sections, timers) =  TimerManager.shared.getAllData()
            
            return Observable.combineLatest(sections, timers)
                .map { sections, timers in
                    // Grouping timers with sectionID
                    let timerDict = Dictionary(grouping: timers, by: { $0.sectionID })
                    
                    // Sorting sections by createdDate
                    let sortedSections = sections.sorted(by: { $0.createdDate > $1.createdDate })
                    
                    return sortedSections.map { section in
                        // Creating sections with timers containing own id
                        let timersInSection = section.isExpanded
                        ? (timerDict[section.id] ?? []).sorted(by: { $0.createdDate > $1.createdDate })
                        : []
                        
                        return CellModel(id: section.id, title: section.title, isExpanded: section.isExpanded, timers: timersInSection)
                    }
                }
                .asDriver(onErrorJustReturn: [])
        }
        
        let showButtons = Signal.merge(
            convertObervableToSignal(input.menuButtonTapEvent),
            convertObervableToSignal(input.controlViewTapEvent)
        )
        
        let presentAddSectionViewController = convertObervableToSignal(input.addSectionButtonTapEvent)
        
        let presentAddTimerViewController = convertObervableToSignal(input.addTimerButtonTapEvent)
        
        let presentSettingsViewController = convertObervableToSignal(input.settingsButtonTapEvent)
        
        return Output(
            data: dataModel,
            showButtons: showButtons,
            presentAddSectionViewController: presentAddSectionViewController,
            presentAddTimerViewController: presentAddTimerViewController,
            presentSettingsViewController: presentSettingsViewController)
    }
    
    func changeSectionState(id: UUID) {
        TimerManager.shared.toggleSectionIsExpanded(id: id)
    }
    
    private func convertObervableToSignal(_ event: Observable<Void>) -> Signal<Void> {
        return event.asSignal(onErrorJustReturn: ())
    }
    
}
