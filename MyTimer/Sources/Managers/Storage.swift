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
    /// URL used to determine the URL for data.
    var filePath: URL { get }
    
    /// Function for saving data to disk.
    func saveData()
    /// Function for loading data from disk.
    func loadData()
    
}

/// Storage for saving and loading data to/from disk.
final class Storage: StorageProtocol {
    
    // MARK: Peoperties
    
    var sections: BehaviorRelay<[Section]>
    var filePath: URL
    
    // MARK: Init
    
    init() {
        sections = BehaviorRelay<[Section]>(value: [])
        filePath = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask)
        .first!
        .appendingPathComponent("RxSections.plist")
        
        loadData()
    }
    
    // MARK: Methods
    
    func saveData() {
        do {
            let data = try PropertyListEncoder().encode(sections.value)
            try data.write(to: filePath)
        } catch {
            print("Failed to save data: \(error)")
        }
    }
    
    func loadData() {
        guard let data = try? Data(contentsOf: filePath) else {
            print("Failed to load data from disk.")
            return
        }
        
        do {
            let loadedSecions = try PropertyListDecoder().decode([Section].self, from: data)
            sections.accept(loadedSecions)
        } catch {
            print("Failed to load data: \(error)")
        }
    }
    
}
