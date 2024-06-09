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
    var id: UUID
    var title: String
    var isExpanded: Bool
    var items: [MyTimer]
    
    init(id: UUID, title: String, isExpanded: Bool, items: [MyTimer]) {
        self.id = id
        self.title = title
        self.isExpanded = isExpanded
        self.items = items
    }
}

// MARK: - Rx

extension CellModel: Equatable, IdentifiableType, AnimatableSectionModelType {
    typealias Identity = UUID
    typealias Item = MyTimer
    
    var identity: UUID {
        return id
    }
    
    init(original: CellModel, items: [Item]) {
        self = original
        self.items = items
    }
}
