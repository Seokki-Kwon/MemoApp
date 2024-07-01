//
//  CalenderViewController.swift
//  MemoAppPratice
//
//  Created by 석기권 on 6/24/24.
//

import UIKit
import RxSwift
import RxCocoa

class CalenderViewController: UIViewController, BindableType {
    @IBOutlet weak var calendarView: CustomCalendar!
    private let bag = DisposeBag()
    
    var viewModel: CalendarViewModel!
    
    func bindViewModel() {
        let seletedDateSubject = BehaviorRelay(value: Date())
        
        let input = CalendarViewModel.Input(seletedDate: seletedDateSubject)
        
        let output = viewModel.transform(input: input)
        
        // 선택된 달의 정보를 바인딩
        calendarView.selectDateSubject
            .bind(to: seletedDateSubject)
            .disposed(by: bag)
        
        // 선택한 달의 메모만 보여주기
        output.currentMonthMemo
            .bind(to: calendarView.memoDataSubject)
            .disposed(by: bag)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
