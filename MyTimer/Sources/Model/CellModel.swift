//
//  CellModel.swift
//  MyTimer
//
//  Created by 권오준 on 2024-05-30.
//

import Foundation
import RxDataSources

/// Model for CollectionView
struct CellModel: IdentifiableType, AnimatableSectionModelType {
    let id: UUID
    let title: String
    let isExpanded: Bool
    var timers: [MyTimer]
    
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
