//
//  MemoComposeViewModel.swift
//  MemoAppPratice
//
//  Created by 석기권 on 6/18/24.
//

import Foundation
import RxSwift
import RxCocoa

class MemoComposeViewModel: ViewModelType {
    var memoComposeRelay = BehaviorRelay<[String]>(value: ["", ""])
    
    override init(storage: MemoStorageType) {
        super.init(storage: storage)
    }

}
