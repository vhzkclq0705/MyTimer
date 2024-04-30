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
        let okButtonTapEvent: Observable<Void>
        let cancelButtonTapEvent: Observable<Void>
    }
    
    struct Output {
        let sectionTitles: Observable<[String]>
        let minutes: Observable<[Int]>
        let seconds: Observable<[Int]>
        let timeUnits: Observable<[String]>
        let titleLength: Driver<Int>
        let createTimer: Signal<Void>
        let dismissViewController: Signal<Void>
    }
    
    var disposeBag = DisposeBag()
    private var title = ""
    private var selectedSection = 0
    private var selectedMinute = 0
    private var selectedSecond = 0
    private var sectionTitles = [String]()
    
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
        
        let sectionTitles = RxTimerManager.shared.getData()
            .map { sections in
                sections.map { $0.title }
            }
            .asObservable()
        
        let times = Observable.just([Int](0...59))
        
        let timeUnits = Observable.just(["분", "초"])
        
        let createTimer = input.okButtonTapEvent
            .asSignal(onErrorJustReturn: ())
        
        let dismissViewController = input.cancelButtonTapEvent
            .asSignal(onErrorJustReturn: ())
        
        return Output(
            sectionTitles: sectionTitles,
            minutes: times,
            seconds: times,
            timeUnits: timeUnits,
            titleLength: titleLength,
            createTimer: createTimer,
            dismissViewController: dismissViewController)
    }
    
    // MARK: Update Selected Items
    
    func updateSelectedSection(newValue: Int) {
        selectedSection = newValue
    }
    
    func updateSelectedTimes() {
        
    }
    
    // MARK: Create Timers
    
    func createTimers() {
        
    }
    
}
