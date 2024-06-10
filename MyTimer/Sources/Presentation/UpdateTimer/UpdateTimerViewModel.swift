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
        let initalSectionTitle: Observable<String>
        let initalMyTimerTitle: Observable<String>
        let initalMinute: Observable<Int>
        let initalSecond: Observable<Int>
        let minutes: Driver<[String]>
        let seconds: Driver<[String]>
        let titleLength: Driver<Int>
        let createTimer: Signal<(Bool, Bool)>
        let dismissViewController: Signal<Void>
    }
    
    private enum InitalObject {
        case SectionTitle
        case TimerTitle
        case Minute
        case Second
    }
    
    var disposeBag = DisposeBag()
    private var sectionID: UUID?
    private var timer: MyTimer?
    private var title: String
    private var selectedSectionIndex: Int
    private var isSectionSelected: Bool
    private var isTitleTyped: Bool
    private var selectedMinute: Int
    private var selectedSecond: Int
    private var sections = [(UUID, String)]()
    
    // MARK: Init
    
    init(sectionID: UUID? = nil, timerID: UUID? = nil) {
        self.sectionID = sectionID
        self.title = timer?.title ?? ""
        self.selectedSectionIndex = 0
        self.isSectionSelected = false
        self.isTitleTyped = timer != nil
        self.selectedMinute = timer?.min ?? 0
        self.selectedSecond = timer?.sec ?? 0
        
        setupBindings()
    }
    
    // MARK: Binding
    
    private func setupBindings() {
        TimerManager.shared.getData().0
            .asObservable()
            .map { sections -> [(UUID, String)] in
                let sortedSections = sections.sorted(by: { $0.createdDate > $1.createdDate })
                return sections.map { ($0.id, $0.title) }
            }
            .subscribe(with: self, onNext: { owner, sections in
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
                return (self.isSectionSelected, !(self.title.isEmpty))
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
            initalSectionTitle: createObservableObjects(object: .SectionTitle),
            initalMyTimerTitle: createObservableObjects(object: .TimerTitle),
            initalMinute: createObservableObjects(object: .Minute).map { Int($0)! },
            initalSecond: createObservableObjects(object: .Second).map { Int($0)! },
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
        if let timer = timer {
            TimerManager.shared.updateTimer(
                sectionID: sections[selectedSectionIndex].0,
                timerID: timer.id,
                title: title,
                min: selectedMinute,
                sec: selectedSecond)
        } else {
            TimerManager.shared.addTimer(
                id: sections[selectedSectionIndex].0,
                title: title,
                min: selectedMinute,
                sec: selectedSecond
            )
        }
    }
    
    // MARK: Others
    
    private func createObservableObjects(object: InitalObject) -> Observable<String> {
        return Observable.create { [weak self] observer in
            if let self = self,
               let timer = self.timer {
                let object: String = switch object {
                case .SectionTitle: self.sections[self.selectedSectionIndex].1
                case .TimerTitle: timer.title
                case .Minute: "\(self.selectedMinute)"
                case .Second: "\(self.selectedSecond)"
                }
                
                observer.onNext(object)
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
}
