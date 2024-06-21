//
//  MemoDetailViewModel.swift
//  MemoAppPratice
//
//  Created by 석기권 on 6/18/24.
//

import Foundation
import RxSwift
import RxCocoa

// input: editButtonStatus,
// output: editModeChanged, deleteMemo, editMemo

// editButtonTap -> editModeChanged
final class MemoDetailViewModel: MemoViewModelType {
    let memo: Memo
    private let bag = DisposeBag()
    private let editModeChangeSubject = PublishSubject<Bool>()
    private lazy var titleSubject = BehaviorSubject(value: memo.title)
    private lazy var contentSubject = BehaviorSubject(value: memo.content)
    
    init(memo: Memo, storage: MemoStorageType) {
        self.memo = memo
        super.init(storage: storage)
    }
}

extension MemoDetailViewModel: ViewModelType {
    // input
    struct Input {
        let editButtonTap: ControlEvent<Void>
        let inputTitle: ControlProperty<String>
        let inputContent: ControlProperty<String>
    }
    
    // output
    struct Output {
        let editModeChanged: Driver<Bool>
        let outputTitle: Driver<String>
        let outputContent: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        input.editButtonTap
            .scan(false) { last, new in !last}
            .bind(to: editModeChangeSubject)
            .disposed(by: bag)
        
        // inputTitle, inputContent를 memoSubject값에 바인딩 해야한다.
        input.inputTitle
            .changed
            .bind(to: titleSubject)
            .disposed(by: bag)
        
        input.inputContent
            .changed
            .bind(to: contentSubject)
            .disposed(by: bag)
        
        editModeChangeSubject
            .filter { !$0 }
            .subscribe { [weak self] _ in self?.performUpdate() }
            .disposed(by: bag)
        
        return Output(editModeChanged: editModeChangeSubject.asDriver(onErrorJustReturn: false),
                      outputTitle: titleSubject.asDriver(onErrorJustReturn: "Some Title"),
                      outputContent: contentSubject.asDriver(onErrorJustReturn: "Some Contents")
        )
    }
    
    func performUpdate() {        
        Observable.zip(titleSubject, contentSubject)
            .map { [weak self] in
                 Memo(id: self!.memo.id, title: $0.0, content: $0.1)}
            .subscribe { self.storage.updateMemo(memo: $0) }
            .disposed(by: bag)
    }
}
