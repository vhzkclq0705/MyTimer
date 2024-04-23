//
//  Storage.swift
//  MyTimer
//
//  Created by 권오준 on 2024-04-23.
//

import Foundation
import RxRelay

/// Protocol for Storage.
protocol StorageProtocol {
    
    /// Array of sections containing timers inside.
    var sections: BehaviorRelay<[Section]> { get }
    
    /// Function for saving data to disk.
    func saveData()
    /// Function for loading data from disk.
    func loadData()
    
}

/// Storage for saving and loading data to/from disk.
final class Storage: StorageProtocol {
    
    // MARK: Peoperties
    
    var sections: BehaviorRelay<[Section]>
    
    // MARK: Init
    
    init() {
        sections = BehaviorRelay<[Section]>(value: [])
        loadData()
    }
    
    // MARK: Methods
    
    func saveData() {
        FileStorageManager.shared.saveData(sections.value)
    }
    
    func loadData() {
        if let data: [Section] = FileStorageManager.shared.loadData() {
            sections.accept(data)
        }
    }
    
}
