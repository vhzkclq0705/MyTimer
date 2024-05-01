//
//  Storage.swift
//  MyTimer
//
//  Created by 권오준 on 2024-04-23.
//

import Foundation
import RxSwift
import RxRelay

/// Protocol for Storage.
protocol StorageProtocol {
    
    /// Array of sections containing timers inside.
    var sections: BehaviorRelay<[RxSection]> { get }
    /// Path used to determine the URL for data.
    var filePath: URL { get }
    var disposeBag: DisposeBag { get set }
    
    /// Function for saving data to disk.
    func saveData()
    /// Function for loading data from disk.
    func loadData()
    
}

/// Storage for saving and loading data to/from disk.
final class Storage: StorageProtocol {
    
    // MARK: Peoperties
    
    var sections = BehaviorRelay<[RxSection]>(value: [])
    var disposeBag = DisposeBag()
    var filePath: URL
    
    // MARK: Init
    
    init() {
        filePath = try! FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true)
        .appendingPathComponent("Test1.plist")
        
        loadData()
        
        sections
            .subscribe(with: self, onNext: { owner, _ in
                owner.saveData()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Data Management
    
    func saveData() {
        do {
            let data = try PropertyListEncoder().encode(sections.value)
            try data.write(to: filePath)
        } catch {
            print("Failed to save data: \(error)")
        }
    }
    
    func loadData() {
        do {
            let data = try Data(contentsOf: filePath)
            let loadedSections = try PropertyListDecoder().decode([RxSection].self, from: data)
            sections.accept(loadedSections)
        } catch {
            print("Failed to load data: \(error)")
        }
    }
    
}
