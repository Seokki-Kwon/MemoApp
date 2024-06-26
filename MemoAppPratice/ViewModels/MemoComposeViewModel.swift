//
//  MemoComposeViewModel.swift
//  MemoAppPratice
//
//  Created by 석기권 on 6/18/24.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

// Input -> title, content, saveButtonTap
// Output -> saveMemo, dismiss
// ControlProperty: Subject같은 개념, UIElement.rx를 통해서 접근

class MemoComposeViewModel: MemoViewModelType, ViewModelType {
    private var memo: Memo
    
    private let bag = DisposeBag()
    private let trigger = PublishSubject<Void>()
    
    private lazy var memoTitleSubject = BehaviorSubject<String>(value: memo.title)
    private lazy var memoContentSubject = BehaviorSubject<String>(value: memo.content)
    
    override init(storage: MemoStorageType) {
        self.memo = Memo(title: "", content: "")
        super.init(storage: storage)
    }
    
    init(memo: Memo, storage: MemoStorageType) {
        self.memo = memo
        super.init(storage: storage)
    }
    
    struct Input {
        let inputTitle: ControlProperty<String>
        let inputContent: ControlProperty<String>
        let saveButtonTap: ControlEvent<Void>
        let closeButtonTap: ControlEvent<Void>        
    }
    
    struct Output {
        let validate: Driver<Bool>
        let editCompleted: Observable<Void>
        let outputTitle: Driver<String>
        let outputContent: Driver<String>
    }
    
    func transform(input: Input) -> Output {        
        let validate = Observable.combineLatest(input.inputTitle, input.inputContent)
            .map { !$0.0.isEmpty && !$0.1.isEmpty}
            .asDriver(onErrorJustReturn: false)
            
        input.inputTitle
            .skip(1)
            .bind(to: memoTitleSubject)
            .disposed(by: bag)
        
        input.inputContent
            .skip(1)
            .bind(to: memoContentSubject)
            .disposed(by: bag)
        
        input.saveButtonTap
            .bind(onNext: performUpdate)
            .disposed(by: bag)
        
        input.closeButtonTap
            .bind(to: trigger)
            .disposed(by: bag)
        
        return Output(validate: validate,
                      editCompleted: trigger,
                      outputTitle: memoTitleSubject.asDriver(onErrorJustReturn: ""),
                      outputContent: memoContentSubject.asDriver(onErrorJustReturn: ""))
    }

    private func performUpdate() {
        do {
            let title = try memoTitleSubject.value()
            let content = try memoContentSubject.value()
            storage.updateMemo(memo: Memo(id: memo.id, title: title, content: content))
                .bind(to: trigger)
                .disposed(by: bag)
        } catch {
            print("Memo update failed")
        }
    }
    
    private func performDelete() {
        
    }
   
}
