//
//  TimerManager.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/30.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - Rx

/// Manager for handling timer and section management operations:
/// adding, deleting, and updating.
final class TimerManager {
    
    // MARK: Properties
    
    static let shared = TimerManager()
    
    private let storage = Storage()
    private let disposeBag = DisposeBag()
    private var sections = BehaviorRelay<[Section]>(value: [])
    private var timers = BehaviorRelay<[MyTimer]>(value: [])
    
    // MARK: Init
    
    private init() {
        let (sectionData, timerData) = storage.getData()
        
        sectionData
            .bind(to: sections)
            .disposed(by: disposeBag)
        
        timerData
            .bind(to: timers)
            .disposed(by: disposeBag)
    }
    
    // MARK: Section Management
    
    func toggleSectionIsExpanded(id: UUID) {
        guard let index = getSectionIndex(id: id) else { return }
        updateStorageSections { sections in
            sections[index].updateIsExpanded()
        }
    }
    
    func createSection(title: String) {
        let newSection = Section(id: UUID(), title: title, isExpanded: false, createdDate: Date(), items: [])
        updateStorageSections { sections in
            sections.append(newSection)
        }
    }
    
    func deleteSection(id: UUID) {
        guard let index = getSectionIndex(id: id) else { return }
        updateStorageSections { sections in
            sections.remove(at: index)
        }
    }
    
    func updateSection(id: UUID, title: String) {
        guard let index = getSectionIndex(id: id) else { return }
        updateStorageSections { sections in
            sections[index].updateTitle(title: title)
        }
    }
    
    // MARK: Timer Management
    
    func addTimer(id: UUID, title: String, min: Int, sec: Int) {
        let newTimer = MyTimer(sectionID: id, id: UUID(), title: title, min: min, sec: sec)
        updateStorageTimers { timers in
            timers.append(newTimer)
        }
    }
    
    func deleteTimer(id: UUID) {
        guard let index = getTimerIndex(id: id) else { return }
        updateStorageTimers { timers in
            timers.remove(at: index)
        }
    }
    
    func updateTimer(sectionID: UUID, timerID: UUID, title: String, min: Int, sec: Int) {
        guard let index = getTimerIndex(id: timerID) else { return }
        updateStorageTimers { timers in
            timers[index].updateTimer(sectionID: sectionID, title: title, min: min, sec: sec)
        }
    }
    
    // MARK: Display Data
    
    func getAllData() -> (BehaviorRelay<[Section]>, BehaviorRelay<[MyTimer]>) {
        return (sections, timers)
    }
    
    func getData() -> Driver<[Section]> {
        return sections
            .map { [weak self] sections in
                let timerDict = Dictionary(grouping: self?.timers.value ?? [], by: { $0.id })
                
                let sortedSections = sections.sorted(by: { $0.createdDate > $1.createdDate })
                
                return sortedSections.map { section in
                    let timers = section.isExpanded
                    ? (timerDict[section.id] ?? []).sorted(by: { $0.createdDate > $1.createdDate })
                    : []
                    
                    return Section(id: section.id, title: section.title, isExpanded: section.isExpanded, createdDate: section.createdDate, items: timers)
                }
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    func getSectionInfo(id: UUID) -> BehaviorRelay<Section?> {
        let section = BehaviorRelay<Section?>(value: nil)
        
        sections
            .map { [weak self] sections in
                guard let index = self?.getSectionIndex(id: id) else { return nil }
                return sections[index]
            }
            .bind(to: section)
            .disposed(by: disposeBag)
        
        return section
    }
    
    func getTimerInfo(id: UUID) -> BehaviorRelay<MyTimer?> {
        let timer = BehaviorRelay<MyTimer?>(value: nil)
        
        timers
            .map { [weak self] timers in
                guard let index = self?.getTimerIndex(id: id) else { return nil }
                return timers[index]
            }
            .bind(to: timer)
            .disposed(by: disposeBag)
        
        return timer
    }
    
//    func getCellModel() -> Driver<[CellModel]> {
//        return Observable.combineLatest(sections, timers)
//            .map { sections, timers in
//                // Grouping timers with sectionID
//                let timerDict = Dictionary(grouping: timers, by: { $0.sectionID })
//                
//                // Sorting sections by createdDate
//                let sortedSections = sections.sorted(by: { $0.createdDate > $1.createdDate })
//                
//                return sortedSections.map { section in
//                    // Creating sections with timers containing own id
//                    let timersInSection = section.isExpanded
//                    ? (timerDict[section.id] ?? []).sorted(by: { $0.createdDate > $1.createdDate })
//                    : []
//                    
//                    return CellModel(id: section.id, title: section.title, isExpanded: section.isExpanded, items: timersInSection)
//                }
//            }
//            .asDriver(onErrorJustReturn: [])
//    }

    // MARK: Hepler Methods
    
    private func getSectionIndex(id: UUID) -> Int? {
        guard let index = sections.value.firstIndex(where: { $0.id == id }) else {
            print("Can not find the ID in sections.")
            return nil
        }
        return index
    }
    
    private func getTimerIndex(id: UUID) -> Int? {
        guard let index = timers.value.firstIndex(where: { $0.id == id }) else {
            print("Can not find the ID in timers.")
            return nil
        }
        return index
    }
    
    private func updateStorageSections(_ completion: (inout [Section]) -> Void) {
        var sections = sections.value
        completion(&sections)
        storage.setSectionData(data: sections)
    }
    
    private func updateStorageTimers(_ completion: (inout [MyTimer]) -> Void) {
        var timers = timers.value
        completion(&timers)
        storage.setTimerData(data: timers)
    }
    
}
