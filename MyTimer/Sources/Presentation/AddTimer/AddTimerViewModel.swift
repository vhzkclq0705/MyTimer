//
//  AddTimerViewModel.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/31.
//

import UIKit
import RxSwift
import RxCocoa

// ViewModel for AddTimerViewController
final class AddTimerViewModel: ViewModelType {
    
    // MARK: Properties
    
    struct Input {
        let title: Observable<String>
        let minSelectEvent: Observable<(row: Int, component: Int)>
        let secSelectEvent: Observable<(row: Int, component: Int)>
        let okButtonTapEvent: Observable<Void>
        let cancelButtonTapEvent: Observable<Void>
    }
    
    struct Output {
        let minutes: Observable<[String]>
        let seconds: Observable<[String]>
        let titleLength: Driver<Int>
        let createTimer: Signal<(Bool, Bool)>
        let dismissViewController: Signal<Void>
    }
    
    var disposeBag = DisposeBag()
    private var title = ""
    private var selectedSection = 0
    private var isSectionSelected = false
    private var isTitleTyped = false
    private var selectedMinute = 0
    private var selectedSecond = 0
    private var sectionTitles = [String]()
    
    // MARK: Init
    
    init() {
        RxTimerManager.shared.getData()
            .map { sections in
                sections.map { $0.title }
            }
            .drive(with: self, onNext: { owner, titles in
                owner.sectionTitles = titles
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Binding
    
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
        
        let times = Observable.just([Int](0...59))
            .map { $0.map { String($0) } }
        
        let createTimer = input.okButtonTapEvent
            .map { [weak self] in
                (self?.isSectionSelected ?? false, self?.isTitleTyped ?? false)
            }
            .asSignal(onErrorJustReturn: (false, false))
        
        let dismissViewController = input.cancelButtonTapEvent
            .asSignal(onErrorJustReturn: ())
        
        return Output(
            minutes: times,
            seconds: times,
            titleLength: titleLength,
            createTimer: createTimer,
            dismissViewController: dismissViewController)
    }
    
    func getTitles() -> [String] {
        return sectionTitles
    }
    
    // MARK: Update Selected Items
    
    func updateSelectedSection(newValue: Int) {
        selectedSection = newValue
        isSectionSelected = true
    }
    
    // MARK: Create Timers
    
    func createTimers() {
        print("create!")
    }
    
}
