//
//  MemoComposeViewModel.swift
//  MemoAppPratice
//
//  Created by 석기권 on 6/18/24.
//

import Foundation
import RxSwift
import RxCocoa

// Input -> title, content, saveButtonTap
// Output -> saveMemo, dismiss
// ControlProperty: Subject같은 개념, UIElement.rx를 통해서 접근

class MemoComposeViewModel: MemoViewModelType, ViewModelType {
    let bag = DisposeBag()
    private let memoSubject = BehaviorRelay(value: Memo(title: "", content: ""))
    private let dismissVCSubject = PublishSubject<Void>()
    
    override init(storage: MemoStorageType) {
        super.init(storage: storage)
    }
    
    struct Input {
        let inputTitle: ControlProperty<String>
        let inputContent: ControlProperty<String>
        let saveButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let validate: Driver<Bool>
        let dismissView: Observable<Void>
    }
    
    func transform(input: Input) -> Output {
        let validate = Observable.combineLatest(input.inputTitle, input.inputContent)
            .do(onNext: { [weak self] (title, content) in
                self?.memoSubject.accept(Memo(title: title, content: content))
            })
            .map { !$0.0.isEmpty && !$0.1.isEmpty}
            
        input.saveButtonTap
            .withUnretained(self)
            .subscribe(onNext: { (vc, _) in
                vc.storage.updateMemo(memo: vc.memoSubject.value)
                .subscribe(onDisposed:  {
                    vc.dismissVCSubject.onCompleted()
                })
                .dispose()
        })
        .disposed(by: bag)
        
        return Output(validate: validate.asDriver(onErrorJustReturn: false), dismissView: dismissVCSubject)
    }
    
   
}
