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
        viewModel.storage.fetchMemos()
            .bind(to: calendarView.memoDataSubject)
            .disposed(by: bag)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
