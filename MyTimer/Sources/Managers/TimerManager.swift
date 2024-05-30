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
    
    func loadData() -> () {
        
    }
    
    func getData() -> BehaviorRelay<[RxSection]> {
        return storage.sections
    }
    
    func getOneSection(id: UUID) -> RxSection? {
        return storage.sections.value.first { $0.id == id }
    }
    
    // MARK: Hepler Methods
    
    private func updateSectionsOfStorage(_ updateCompletion: (inout [RxSection]) -> Void) {
        var sections = storage.sections.value
        updateCompletion(&sections)
        
        storage.sections.accept(sections)
    }
    
}
