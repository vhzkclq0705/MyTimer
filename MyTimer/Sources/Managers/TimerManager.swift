//
//  TimerManager.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/30.
//

import Foundation
import RxSwift
import RxCocoa

class TimerManager {
    
    // MARK: - Property
    static let shared = TimerManager()
    
    var lastSectionID: Int = 0
    var sections = [Section]()
    
    private init() {}
    
    // MARK: - Sections
    func addSection(_ title: String) {
        let nextSectionID = lastSectionID + 1
        lastSectionID = nextSectionID
        
        let section = Section(
            id: nextSectionID,
            title: title,
            timers: [])
        
        sections.append(section)
        
        save()
    }
    
    func setSection(section: Section, title: String) {
        guard let index: Int = sections.firstIndex(of: section) else {
            return
        }
        
        sections[index].title = title
        
        save()
    }
    
    func deleteSection(_ section: Section) {
        sections = sections.filter { $0.id != section.id }
        
        save()
    }
    
    // MARK: - Timers
    func addTimer(section: Int, title: String, min: Int, sec: Int) {
        let lastTimerID = sections[section].timers.last?.id ?? 0
        let nextTimerID = lastTimerID + 1
        let timer = MyTimer(
            id: nextTimerID,
            title: title,
            min: min,
            sec: sec)
        
        sections[section].timers.append(timer)
        
        save()
    }
    
    func setTimer(section: Int, id: Int, title: String, min: Int, sec: Int) {
        let timers = sections[section].timers
        let timer = (timers.filter { $0.id == id })[0]
        guard let index: Int = timers.firstIndex(of: timer) else {
            return
        }
        let setTimer = MyTimer(id: id, title: title, min: min, sec: sec)
        
        sections[section].timers[index] = setTimer
        
        save()
    }
    
    func deleteTimer(sectionTitle: String, timer: MyTimer) {
        let section = (sections.filter { $0.title == sectionTitle })[0]
        guard let index: Int = sections.firstIndex(of: section) else {
            return
        }
        
        sections[index].timers = sections[index].timers.filter {
            $0.id != timer.id
        }
        
        save()
    }
    
    // MARK: - Save and load data
    func save() {
        UserDefaults.standard.set(
            try? PropertyListEncoder().encode(sections),
            forKey: "Sections")
    }
    
    func load() {
        guard let data = UserDefaults.standard.data(forKey: "Sections") else { return
        }
        
        sections = (try? PropertyListDecoder().decode(
            [Section].self,
            from: data)) ?? []
        
        lastSectionID = sections.last?.id ?? 0
    }
}

// MARK: - Rx

/// Manager for handling timer and section management operations:
/// adding, deleting, and updating.
final class RxTimerManager {
    
    // MARK: Properties
    
    static let shared = RxTimerManager()
    
    private let storage: StorageProtocol
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    
    private init(storage: StorageProtocol = Storage()) {
        self.storage = storage
        
        bindStorageUpdates()
    }
    
    private func bindStorageUpdates() {
        storage.sections
            .subscribe(
                onNext: { sections in
                    print("Sections changed: \(sections)")
                },
                onError: { error in
                    print("Failed to change sections: \(error)")
                })
            .disposed(by: disposeBag)
    }
    
    // MARK: Section Management
    
    func changeSectionExpandedState(id: UUID) {
        updateSectionsOfStorage { sections in
            if let index = sections.firstIndex(where: { $0.id == id }) {
                sections[index].isExpanded.toggle()
            }
        }
    }
    
    func addSection(title: String) {
        updateSectionsOfStorage { sections in
            sections.append(RxSection(id: UUID(), title: title, isExpanded: true, items: []))
        }
    }
    
    func deleteSection(id: UUID) {
        updateSectionsOfStorage { sections in
            sections.removeAll(where: { $0.id == id })
        }
    }
    
    func updateSection(id: UUID, title: String) {
        updateSectionsOfStorage { sections in
            if let index = sections.firstIndex(where: { $0.id == id }) {
                sections[index].title = title
            }
        }
    }
    
    // MARK: Timer Management
    
    func addTimer(id: UUID, title: String, min: Int, sec: Int) {
        updateSectionsOfStorage { sections in
            if let index = sections.firstIndex(where: { $0.id == id }) {
                sections[index].addTimer(title: title, min: min, sec: sec)
            }
        }
    }
    
    func deleteTimer(sectionID: UUID, timerID: UUID) {
        updateSectionsOfStorage { sections in
            if let index = sections.firstIndex(where: { $0.id == sectionID }) {
                sections[index].deleteTimer(id: timerID)
            }
        }
    }
    
    func updateTimer(sectionID: UUID, timerID: UUID, title: String, min: Int, sec: Int) {
        updateSectionsOfStorage { sections in
            if let index = sections.firstIndex(where: { $0.id == sectionID }) {
                sections[index].updateTimer(id: timerID, title: title, min: min, sec: sec)
            }
        }
    }
    
    // MARK: Display Data
    
    func getData() -> Driver<[RxSection]> {
        return storage.sections.asDriver(onErrorJustReturn: [])
    }
    
    // MARK: Hepler Methods
    
    private func updateSectionsOfStorage(_ updateCompletion: (inout [RxSection]) -> Void) {
        var sections = storage.sections.value
        updateCompletion(&sections)
        
        storage.sections.accept(sections)
    }
    
}
