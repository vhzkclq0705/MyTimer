//
//  DetailTimerViewModel.swift
//  MyTimer
//
//  Created by 권오준 on 2022/06/03.
//

import Foundation
import RxSwift
import RxCocoa

/// ViewModel for DetailTimerViewController
final class DetailTimerViewModel: ViewModelType {
    
    // MARK: Properties
    
    struct Input {
        let resetButtonTapEvent: Observable<Void>
        let timerStateButtonTapEvent: Observable<Void>
        let backButtonTapEvent: Observable<Void>
        let settingsButtonTapEvent: Observable<Void>
        let deleteButtonTapEvent: Observable<Void>
        let bellButtonTapEvent: Observable<Void>
    }
    
    struct Output {
        let titles: Driver<(String, String)>
        let remainingTimeText: Driver<String>
        let sendNotification: Signal<Void>
        let resetTimer: Signal<Void>
        let changeTimerState: Signal<Void>
        let presentSettingsViewController: Signal<Void>
        let deleteTimer: Signal<Void>
        let removeAlarm: Signal<Void>
        let dismissViewController: Signal<Void>
    }
    
    var disposeBag = DisposeBag()
    private var timeEnteredBackground: Date?
    private let sectionTitle: String
    private let sectionID: UUID
    private let myTimerID: UUID
    private let myTimer: RxMyTimer
    private var remainingTime: Observable<Double>
    private var timer: Disposable?
    
    // MARK: Init
    
    init(sectionTitle: String, sectionID: UUID, timerID: UUID) {
        self.sectionTitle = sectionTitle
        self.sectionID = sectionID
        self.myTimerID = timerID
        
        if let myTimer = RxTimerManager.shared.getOneSection(id: sectionID)?.getOneTimer(id: timerID) {
            self.myTimer = myTimer
            self.remainingTime = Observable
                .just(Double(myTimer.min * 60 + myTimer.sec))
                .share()
        } else {
            fatalError("Timer not found.")
        }
    }
    
    // MARK: Binding
    
    func transform(input: Input) -> Output {
        let titles = Driver.just((sectionTitle, myTimer.title))
        
        let remainingTimeText = remainingTime
            .map { time in
                let min = String(format: "%02d", Int(time / 60))
                let sec = String(format: "%02d", Int(time.truncatingRemainder(dividingBy: 60)))
                return "\(min) : \(sec)"
            }
            .asDriver(onErrorJustReturn: "00 : 00")
        
        let sendNotification = remainingTime
            .filter { $0 <= 0 }
            .map { _ in }
            .asSignal(onErrorJustReturn: ())
        
        let resetTimer = input.resetButtonTapEvent
            .asSignal(onErrorJustReturn: ())
        
        let changeTimerState = input.timerStateButtonTapEvent
            .asSignal(onErrorJustReturn: ())
        
        let presentSettingsViewController = input.settingsButtonTapEvent
            .asSignal(onErrorJustReturn: ())
        
        let deleteTimer = input.deleteButtonTapEvent
            .asSignal(onErrorJustReturn: ())
        
        let removeAlarm = input.bellButtonTapEvent
            .asSignal(onErrorJustReturn: ())
        
        let dismissViewController = input.backButtonTapEvent
            .asSignal(onErrorJustReturn: ())
        
        return Output(
            titles: titles,
            remainingTimeText: remainingTimeText,
            sendNotification: sendNotification,
            resetTimer: resetTimer,
            changeTimerState: changeTimerState,
            presentSettingsViewController: presentSettingsViewController,
            deleteTimer: deleteTimer,
            removeAlarm: removeAlarm,
            dismissViewController: dismissViewController)
    }
    
//    var time: Double!
//    var myTimer: MyTimer!
//    var section: String!
//    
//    // MARK: - UI
//    var sectionTitle: String {
//        return section
//    }
//    
//    var title: String {
//        return myTimer.title
//    }
//    
//    var remainingTime: Double {
//        return time
//    }
//    
//    var min: String {
//        return String(format: "%02d", Int(time / 60))
//    }
//    
//    var sec: String {
//        return String(
//            format: "%02d",
//            Int(time.truncatingRemainder(dividingBy: 60)))
//    }
//    
//    // MARK: - Timer
//    func initTime(){
//        time = Double(myTimer.min * 60 + myTimer.sec)
//    }
//    
//    func updateCounter() {
//        time -= 0.1
//    }
//    
//    func finish() {
//        time = 0
//    }
//    
//    func timeIntervalInBackground(_ interval: Double) {
//        time -= (interval * 100).rounded() / 100
//        if time < 0 {
//            time = 0
//        }
//    }
//    
//    // MARK: - Load
//    func loadTimer(sectionTitle: String, myTimer: MyTimer) {
//        self.section = sectionTitle
//        self.myTimer = myTimer
//        initTime()
//    }
}
