//
//  CalendarViewModel.swift
//  DayPlanner
//
//  Created by 석기권 on 6/30/24.
//

import UIKit
import RxSwift
import RxCocoa

final class CalendarViewModel: MemoViewModelType, ViewModelType {
    private var memoData: Observable<[Memo]> {
        return storage.fetchMemos()
    }
    private let bag = DisposeBag()
    private let currentMonthMemo = BehaviorRelay<[Memo]>(value: [])
    
    struct Input {
        let seletedDate: BehaviorRelay<Date>
    }
    struct Output {
        let seletedDate: Observable<Date>
        let currentMonthMemo: Observable<[Memo]>
    }
    
    func transform(input: Input) -> Output {
        input.seletedDate
            .withUnretained(self)
            .subscribe(onNext: { (owner, date) in
                owner.memoData
                    .subscribe(onNext: { memoArray in
                       let filterMemo = memoArray.filter { $0.date.checkCurrnetMotnh(date: date) }
                        owner.currentMonthMemo.accept(filterMemo)
                    })
                    .disposed(by: owner.bag)
            })
            .disposed(by: bag)
        
        return Output(
            seletedDate: input.seletedDate.asObservable(),
            currentMonthMemo: currentMonthMemo.asObservable()
        )
    }
}
