//
//  MemoDetailViewModel.swift
//  MemoAppPratice
//
//  Created by 석기권 on 6/18/24.
//

import Foundation
import RxSwift
import RxCocoa

class MemoDetailViewModel: ViewModelType {
    let memo: Memo
    lazy var memoSubject = BehaviorRelay<Memo>(value: memo)
    var editModeSubject = PublishSubject<Bool>()
    var newMemo: Memo {
        memoSubject.value
    }
    
    init(memo: Memo, storage: MemoStorageType) {
        self.memo = memo
        super.init(storage: storage)        
    }
    
    func performUpdate() {
        storage.updateMemo(memo: memoSubject.value)
    }
    
    func updateContent(content: String) {
        memoSubject.accept(Memo(id: newMemo.id, title: newMemo.title, content: content))
    }
    
    func updateTitle(title: String) {
        memoSubject.accept(Memo(id: newMemo.id, title: title, content: newMemo.content))
    }
}
