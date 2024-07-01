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
        Observable.combineLatest(input.seletedDate, memoData)
            .map { (date, memoArray) in
                memoArray.filter { $0.date.checkCurrnetMotnh(date: date)}
            }
            .bind(to: currentMonthMemo)
            .disposed(by: bag)
        
        return Output(
            seletedDate: input.seletedDate.asObservable(),
            currentMonthMemo: currentMonthMemo.asObservable()
        )
    }
}
