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
    private var seleteDateSubject = BehaviorRelay<Date>(value: Date())
    
    struct Input {}
    struct Output {}
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
