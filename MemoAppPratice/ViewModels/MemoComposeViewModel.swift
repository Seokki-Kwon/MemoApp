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
    var memoComposeSbuject = BehaviorRelay<Memo>(value: Memo(title: "", content: ""))
    var currentMemo: Memo {
        memoComposeSbuject.value
    }
    override init(storage: MemoStorageType) {
        super.init(storage: storage)
    }
    
    func updateTitle(title: String) {
        memoComposeSbuject.accept(Memo(id: currentMemo.id, title: title, content: currentMemo.content))
    }
    
    func updateContent(content: String) {
        memoComposeSbuject.accept(Memo(id: currentMemo.id, title: currentMemo.title, content: content))
    }
    
    func performUpdate() {
        storage.updateMemo(memo: memoComposeSbuject.value)
    }
}
