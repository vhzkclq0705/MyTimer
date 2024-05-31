//
//  CellModel.swift
//  MyTimer
//
//  Created by 권오준 on 2024-05-30.
//

import Foundation
import RxDataSources

/// Model for CollectionView
struct CellModel {
    let id: UUID
    let title: String
    let isExpanded: Bool
    var timers: [MyTimer]
    
    init(id: UUID, title: String, isExpanded: Bool, timers: [MyTimer]) {
        self.id = id
        self.title = title
        self.isExpanded = isExpanded
        self.timers = timers
    }
}

// MARK: - Rx

extension CellModel: Equatable, IdentifiableType, AnimatableSectionModelType {
    var identity: UUID {
            return id
        }
        
    var items: [MyTimer] {
        return timers
    }
    
    init(original: CellModel, items: [MyTimer]) {
        self = original
        self.timers = items
    }
}
