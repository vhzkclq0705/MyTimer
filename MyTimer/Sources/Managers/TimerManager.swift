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
    
    private let storage = Storage()
    private let disposeBag = DisposeBag()
    private var sections: BehaviorRelay<[Section]>
    private var timers: BehaviorRelay<[MyTimer]>
    
    // MARK: Init
    
    private init() {
        let (sectionData, timerData) = storage.getData()
        
        self.sections = sectionData
        self.timers = timerData
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
    
    func getData() -> (BehaviorRelay<[Section]>, BehaviorRelay<[MyTimer]>) {
        return (sections, timers)
    }
    

    // MARK: Hepler Methods
    
    private func updateSectionsOfStorage(_ updateCompletion: (inout [RxSection]) -> Void) {

    }
    
}
