//
//  ViewModelType.swift
//  MyTimer
//
//  Created by 권오준 on 2024-04-23.
//

import Foundation

import RxSwift

/// Contains basic properties of ViewModel
protocol ViewModelType {
    
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
    
}
