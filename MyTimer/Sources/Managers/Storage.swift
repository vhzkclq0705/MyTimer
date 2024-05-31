//
//  Storage.swift
//  MyTimer
//
//  Created by 권오준 on 2024-04-23.
//

import Foundation
import RxSwift
import RxRelay

/// Storage for saving and loading data to/from disk.
final class Storage {
    
    // MARK: Peoperties
    
    private var sectionData = BehaviorRelay<[Section]>(value: [])
    private var timerData = BehaviorRelay<[MyTimer]>(value: [])
    private var disposeBag = DisposeBag()
    private var sectionFilePath: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("S.json")
    }
    private var timerFilePath: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("T.json")
    }
    
    // MARK: Init
    
    init() {
        loadData()
        
        sectionData
            .subscribe(with: self, onNext: { owner, _ in
                owner.saveSectionData()
            })
            .disposed(by: disposeBag)
        
        timerData
            .subscribe(with: self, onNext: { owner, _ in
                owner.saveTimerData()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Send Data
    
    func getData() -> (BehaviorRelay<[Section]>, BehaviorRelay<[MyTimer]>) {
        return (sectionData, timerData)
    }
    
    // MARK: Data Management
    
    private func saveSectionData() {
        do {
            try JSONEncoder().encode(sectionData.value).write(to: sectionFilePath)
        } catch {
            print("Failed to save data: \(error)")
        }
    }
    
    private func saveTimerData() {
        do {
            try JSONEncoder().encode(timerData.value).write(to: timerFilePath)
        } catch {
            print("Failed to save data: \(error)")
        }
    }
    
    private func loadData() {
        do {
            let sectionData = try Data(contentsOf: sectionFilePath)
            let sections = try JSONDecoder().decode([Section].self, from: sectionData)
            self.sectionData.accept(sections)
        } catch {
            print("Failed to load sectiom data: \(error)")
        }
        do {
            let timerData = try Data(contentsOf: timerFilePath)
            let timers = try JSONDecoder().decode([MyTimer].self, from: timerData)
            self.timerData.accept(timers)
        } catch {
            print("Failed to load data: \(error)")
        }
    }
    
}
