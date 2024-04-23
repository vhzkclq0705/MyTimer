//
//  FileStroageManager.swift
//  MyTimer
//
//  Created by 권오준 on 2024-04-23.
//

import Foundation

/// Manager for managing FileSystem
final class FileStorageManager {
    
    // MARK: Properties
    
    static let shared = FileStorageManager()
    
    private let fileName: String = "RxSections.plist"
    
    private var documentsDirectory: URL {
        return FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask)
        .first!
    }
    
    private var dataFilePath: URL {
        return documentsDirectory.appendingPathComponent(fileName)
    }
    
    // MARK: Methods
    
    func saveData(_ data: [Section]) {
        let filePath = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            let data = try PropertyListEncoder().encode(data)
            try data.write(to: filePath)
        } catch {
            print("Failed to save data: \(error)")
        }
    }
    
    func loadData() -> [Section]? {
        let filePath = documentsDirectory.appendingPathComponent(fileName)
        guard let data = try? Data(contentsOf: filePath) else {
            return nil
        }
        
        do {
            return try PropertyListDecoder().decode([Section].self, from: data)
        } catch {
            print("Failed to load data: \(error)")
            return nil
        }
    }
    
    
}
