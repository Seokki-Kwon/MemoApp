//
//  MemoListViewModel.swift
//  MemoAppPratice
//
//  Created by 석기권 on 6/17/24.
//

import Foundation
import RxSwift
import RxCocoa

// input: addButtonTap, modelSelected
// output: showComposeMemoVC
final class MemoListViewModel: MemoViewModelType, ViewModelType {
    private let bag = DisposeBag()
    private let memoComposeTrigger = PublishSubject<Void>()
    private let memoCellSubject = PublishSubject<Memo>()
    
    private var memos: Observable<[Memo]> {
        return storage.getAllMemo()
    }
    
    struct Input {
        let addButtonTap: ControlEvent<Void>
        let memoCellSelected: ControlEvent<Memo>
    }
    struct Output {
        let tableViewDriver: Driver<[Memo]>
        let presentMemoComposeVC: Observable<Void>
        let goToMemoDetailVC: Observable<Memo>
    }
    
    func transform(input: Input) -> Output {
        input.memoCellSelected
            .bind(to: memoCellSubject)
            .disposed(by: bag)
        
        input.addButtonTap
            .bind(to: memoComposeTrigger)
            .disposed(by: bag)
        
        return Output(tableViewDriver: memos.asDriver(onErrorJustReturn: []), presentMemoComposeVC: memoComposeTrigger,
                      goToMemoDetailVC: memoCellSubject)
    }
}
