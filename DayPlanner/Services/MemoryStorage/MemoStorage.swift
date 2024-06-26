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
final class MemoStorage: MemoStorageType {
    func createMemo(memo: Memo) -> RxSwift.Observable<Void> {
        return Observable.empty()
    }
    
    private var memoList: [Memo] = []
    
    private lazy var store = BehaviorRelay(value: memoList)
    
    init(memoList: [Memo] = []) {
        self.memoList = memoList
    }
    
    func fetchMemos() -> Observable<[Memo]> {
        return store.asObservable()
    }
    
    func updateMemo(memo: Memo) -> Observable<Void> {
        let findMemo = store.value.filter { $0.id == memo.id }
        var updateMemo = store.value
        
        if !findMemo.isEmpty {
            let index = store.value.firstIndex(where: { $0.id == findMemo[0].id })!
            updateMemo[index] = memo
        } else {
            updateMemo.insert(memo, at: 0)
        }
        
        store.accept(updateMemo)
        return Observable.just(())
    }
    
    func deleteMemo(memo: Memo) -> Observable<Void> {
        let newList = store.value.filter { memo.id != $0.id }
        store.accept(newList)
        return Observable.empty()
    }
}
