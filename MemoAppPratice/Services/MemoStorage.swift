//
//  MemoStorage.swift
//  MemoAppPratice
//
//  Created by 석기권 on 6/17/24.
//

import Foundation
import RxSwift
import RxCocoa

// 메모데이터 관련
class MemoStorage: MemoStorageType {
    private var memoList: [Memo] = []
    
    private lazy var store = BehaviorRelay(value: memoList)
    
    func getAllMemo() -> Observable<[Memo]> {
        return store.asObservable()
    }
    
    func updateMemo(memo: Memo) -> Observable<Memo> {
        let findMemo = store.value.filter { $0.id == memo.id }
        var updateMemo = store.value
        
        if !findMemo.isEmpty {
            let index = store.value.firstIndex(where: { $0.id == findMemo[0].id })!
            updateMemo[index] = memo
        } else {
            updateMemo.insert(memo, at: 0)
        }
        
        store.accept(updateMemo)
        return Observable.just(memo)
    }
    
    func deleteMemo(memo: Memo) -> Observable<Void> {
        return Observable.empty()
    }
}
