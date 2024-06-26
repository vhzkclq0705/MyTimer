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
        let initTime: Driver<Double>
        let remainingTimeText: Driver<String>
        let sendNotification: Signal<Void>
        let resetTimer: Signal<Void>
        let changeTimerState: Signal<Void>
        let presentSettingsViewController: Signal<(UUID, UUID)>
        let deleteTimer: Signal<Void>
        let removeAlarm: Signal<Void>
        let dismissViewController: Signal<Void>
    }
    
    var disposeBag = DisposeBag()
    private var timeEnteredBackground: Date?
    private let sectionID: UUID
    private let timerID: UUID
    private var initialTime: Double = 0
    private let notificationID = "Push"
    private let notificationCenter = UNUserNotificationCenter.current()
    private var remainingTime = BehaviorSubject<Double>(value: 0)
    private var timer: Disposable?
    private var timeInBackground: Date?
    private var isProgressing = false
    
    // MARK: Init
    
    init(sectionID: UUID, timerID: UUID) {
        self.sectionID = sectionID
        self.timerID = timerID
        
        setupNotificationCenterBindings()
        initRemainingTime()
    }
    
    // MARK: Binding
    
    func transform(input: Input) -> Output {
        let section = TimerManager.shared.getSectionInfo(id: sectionID)
            .compactMap { $0 }
        
        let myTimer = TimerManager.shared.getTimerInfo(id: timerID)
            .compactMap { $0 }
            
        myTimer
            .subscribe(with: self, onNext: { owner, timer in
                let time = Double(timer.min * 60 + timer.sec)
                owner.initialTime = time
                owner.remainingTime.onNext(time)
            })
            .disposed(by: disposeBag)
        
        let sectionTitle = section
            .map { section in
                return section.title
            }
        
        let timerTitle = myTimer
            .map { timer in
                return timer.title
            }
        
        let titles = Observable.combineLatest(sectionTitle, timerTitle)
            .map { sectionTitle, timerTitle in
                return (sectionTitle, timerTitle)
            }
            .asDriver(onErrorJustReturn: ("", ""))
        
        let remainingTimeText = remainingTime
            .map { time -> String in
                let time = max(time, 0)
                let min = String(format: "%02d", Int(time / 60))
                let sec = String(format: "%02d", Int(time.truncatingRemainder(dividingBy: 60)))
                return "\(min) : \(sec)"
            }
            .asDriver(onErrorJustReturn: "00 : 00")
        
        let sendNotification = handleEvents(
            remainingTime
                .filter { $0 < 0 }
                .map { _ in () },
            action: pauseTimer)
        
        let resetTimer = handleEvents(input.resetButtonTapEvent, action: initRemainingTime)
        
        let changeTimerState = handleEvents(input.timerStateButtonTapEvent, action: toggleTimerState)
        
        let removeAlarm = handleEvents(input.bellButtonTapEvent, action: initRemainingTime)
        
        let deleteTimer = handleEvents(input.deleteButtonTapEvent, action: deleteTimers)
        
        let presentSettingsViewController = input.settingsButtonTapEvent
            .map { [weak self] _ -> (UUID, UUID)? in
                guard let self = self else { return nil }
                return (self.sectionID, self.timerID)
            }
            .asSignal(onErrorJustReturn: nil)
            .compactMap { $0 }
        
        let dismissViewController = input.backButtonTapEvent
            .asSignal(onErrorJustReturn: ())
        
        return Output(
            titles: titles,
            initTime: Driver.just(initialTime),
            remainingTimeText: remainingTimeText,
            sendNotification: sendNotification,
            resetTimer: resetTimer,
            changeTimerState: changeTimerState,
            presentSettingsViewController: presentSettingsViewController,
            deleteTimer: deleteTimer,
            removeAlarm: removeAlarm,
            dismissViewController: dismissViewController)
    }
    
    private func setupNotificationCenterBindings() {
        NotificationCenter.default.rx.notification(UIApplication.willResignActiveNotification)
            .asDriver(onErrorJustReturn: Notification(name: UIApplication.willResignActiveNotification))
            .drive(with: self, onNext: { owner, _ in
                print("resign")
                owner.movedToBackground()
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIApplication.didBecomeActiveNotification)
            .asDriver(onErrorJustReturn: Notification(name: UIApplication.didBecomeActiveNotification))
            .drive(with: self, onNext: { owner, _ in
                print("active")
                owner.movedToForeground()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Timer Actions
    
    private func startTimer() {
        isProgressing = true
        createPushNotification()
        timer = Observable<Int>
            .interval(.milliseconds(100), scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                owner.remainingTime
                    .take(1)
                    .subscribe(onNext: { time in
                        owner.remainingTime.onNext(time - 0.1)
                    })
                    .disposed(by: owner.disposeBag)
            })
    }
    
    private func pauseTimer() {
        isProgressing = false
        timer?.dispose()
    }
    
    private func initRemainingTime() {
        pauseTimer()
        remainingTime.onNext(initialTime)
    }
    
    private func toggleTimerState() {
        if isProgressing {
            pauseTimer()
            notificationCenter.removePendingNotificationRequests(withIdentifiers: [notificationID])
        } else {
            startTimer()
        }
    }
    
    // MARK: Notification Actions
    
    private func movedToBackground() {
        if isProgressing {
            timeInBackground = Date()
            pauseTimer()
        }
    }
    
    private func movedToForeground() {
        guard let timeInBackground = timeInBackground,
              let time = try? remainingTime.value() else {
            return
        }
        let elapsedTime = Date().timeIntervalSince(timeInBackground)
        
        remainingTime.onNext(time - elapsedTime)
        startTimer()
        
        self.timeInBackground = nil
    }
    
    private func createPushNotification() {
        let notiContent = UNMutableNotificationContent()
        notiContent.body = "시간이 되었습니다!!"
        notiContent.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "\(alarmSound).mp3"))
        
        remainingTime
            .take(1)
            .filter { $0 > 0 }
            .subscribe(onNext: { [weak self] timeInterval in
                guard let self = self else { return }
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
                let request = UNNotificationRequest(identifier: self.notificationID, content: notiContent, trigger: trigger)
                
                self.notificationCenter.add(request) { error in
                    if let error = error { print(error) }
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Delete Timers
    
    private func deleteTimers() {
        TimerManager.shared.deleteTimer(id: timerID)
    }
    
    // MARK: Helper Methods
    
    private func getIDs() {
        
    }
    
    private func handleEvents(_ event: Observable<Void>, action: @escaping () -> Void) -> Signal<Void> {
        return event
            .do(onNext: {
                action()
            })
            .asSignal(onErrorJustReturn: ())
    }

}
