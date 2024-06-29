//
//  ViewModelType.swift
//  MemoAppPratice
//
//  Created by 석기권 on 6/17/24.
//

import Foundation
import RxSwift
// ViewModel이 상속하는 클래스
protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output    
}

class MemoViewModelType {
    let storage: MemoStorageType
    
    init(storage: MemoStorageType) {
        self.storage = storage
    }
}
