//
//  UpdateTimerViewModel.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/31.
//

import UIKit
import RxSwift
import RxCocoa

// ViewModel for UpdateTimerViewController
final class UpdateTimerViewModel: ViewModelType {
    
    // MARK: Properties
    
    struct Input {
        let title: Observable<String>
        let minSelectEvent: Observable<(row: Int, component: Int)>
        let secSelectEvent: Observable<(row: Int, component: Int)>
        let okButtonTapEvent: Observable<Void>
        let cancelButtonTapEvent: Observable<Void>
    }
    
    struct Output {
        let initalMinute: Observable<Int>
        let initalSecond: Observable<Int>
        let minutes: Driver<[String]>
        let seconds: Driver<[String]>
        let titleLength: Driver<Int>
        let createTimer: Signal<(Bool, Bool)>
        let dismissViewController: Signal<Void>
    }
    
    var disposeBag = DisposeBag()
    private var sectionID: UUID?
    private var myTimer: RxMyTimer?
    private var title: String
    private var selectedSectionIndex: Int
    private var isSectionSelected: Bool
    private var isTitleTyped: Bool
    private var selectedMinute: Int
    private var selectedSecond: Int
    private var sections = [(UUID, String)]()
    
    // MARK: Init
    
    init(sectionID: UUID? = nil, myTimer: RxMyTimer? = nil) {
        self.sectionID = sectionID
        self.myTimer = myTimer
        self.title = myTimer?.title ?? ""
        self.selectedSectionIndex = 0
        self.isSectionSelected = false
        self.isTitleTyped = myTimer != nil
        self.selectedMinute = myTimer?.min ?? 0
        self.selectedSecond = myTimer?.sec ?? 0
        
        setupBindings()
    }
    
    // MARK: Binding
    
    private func setupBindings() {
        RxTimerManager.shared.getData()
            .take(1)
            .map { sections in
                sections.map { ($0.id, $0.title) }
            }
            .asDriver(onErrorJustReturn: [])
            .drive(with: self, onNext: { owner, sections in
                owner.sections = sections
                if let sectionID = owner.sectionID,
                   let selectedSectionIndex = sections.firstIndex(where: { $0.0 == sectionID }) {
                    owner.selectedSectionIndex = selectedSectionIndex
                    owner.isSectionSelected = true
                }
            })
            .disposed(by: disposeBag)
    }
    
    func transform(input: Input) -> Output {
        let inputTitle = input.title.share(replay: 1, scope: .whileConnected)
        
        inputTitle
            .filter { $0 != "타이머 이름을 입력해주세요." }
            .subscribe(with: self, onNext: { owner, title in
                owner.title = title
                owner.isTitleTyped = true
            })
            .disposed(by: disposeBag)
        
        input.minSelectEvent
            .subscribe(with: self, onNext: { owner, item in
                owner.selectedMinute = item.row
            })
            .disposed(by: disposeBag)
        
        input.secSelectEvent
            .subscribe(with: self, onNext: { owner, item in
                owner.selectedSecond = item.row
            })
            .disposed(by: disposeBag)
        
        let titleLength = inputTitle
            .map { $0.count }
            .asDriver(onErrorJustReturn: 0)
        
        let times = Driver.just([Int](0...59))
            .map { $0.map { String($0) } }
        
        let createTimer = input.okButtonTapEvent
            .map { [weak self] _ -> (Bool, Bool) in
                guard let self = self else { return (false, false) }
                return (self.isSectionSelected, self.isTitleTyped)
            }
            .do(onNext: { [weak self] validated in
                guard let self = self else { return }
                if validated.0 && validated.1 {
                    self.updateTimers()
                }
            })
            .asSignal(onErrorJustReturn: (false, false))
        
        let dismissViewController = input.cancelButtonTapEvent
            .asSignal(onErrorJustReturn: ())
        
        return Output(
            initalMinute: Observable.just(selectedMinute).take(1),
            initalSecond: Observable.just(selectedSecond).take(1),
            minutes: times,
            seconds: times,
            titleLength: titleLength,
            createTimer: createTimer,
            dismissViewController: dismissViewController)
    }
    
    // MARK: - Helper Methods
    
    
    // MARK: DropDown
    
    func getTitles() -> [String] {
        return sections.map { $0.1 }
    }
    
    func getSelectedSectionIndex() -> Int {
        return selectedSectionIndex
    }
    
    func updateSelectedSection(newValue: Int) {
        selectedSectionIndex = newValue
        isSectionSelected = true
    }
    
    // MARK: Create or Update Timers
    
    private func updateTimers() {
        if let myTimer = myTimer {
            RxTimerManager.shared.updateTimer(
                sectionID: sections[selectedSectionIndex].0,
                timerID: myTimer.id,
                title: title,
                min: selectedMinute,
                sec: selectedSecond)
        } else {
            RxTimerManager.shared.addTimer(
                id: sections[selectedSectionIndex].0,
                title: title,
                min: selectedMinute,
                sec: selectedSecond
            )
        }
    }
    
}
