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
    @IBOutlet weak var currentDayLabel: UILabel!
    @IBOutlet weak var todayButton: UIButton!
    
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
        
        calendarView.currentDate
            .map { $0.toDateString }
            .bind(to: currentDayLabel.rx.text)
            .disposed(by: bag)
                
        // 선택한 달의 메모만 보여주기
        output.currentMonthMemo
            .bind(to: calendarView.memoDataSubject)
            .disposed(by: bag)
        
        // seleteDate와 오늘의 달이 같은지 확인
        // 같지 않으면 false
        // 같으면 true
        calendarView.selectDateSubject
            .map { $0.checkCurrnetMotnh(date: Date())}
            .bind(onNext: showTodayButton)
            .disposed(by: bag)
        
        todayButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { (owner, _) in
                owner.calendarView.selectDateSubject.accept(Date())
            })
            .disposed(by: bag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        todayButton.layer.shadowColor = UIColor.lightGray.cgColor
        todayButton.layer.shadowOpacity = 0.8
        todayButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        todayButton.layer.shadowRadius = 2
        todayButton.layer.masksToBounds = false
        todayButton.layer.cornerRadius = 20
        todayButton.layer.backgroundColor = UIColor.white.cgColor
        todayButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func showTodayButton(isShow: Bool) {
        let yPosition: CGFloat = isShow ? 20 : -100
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.todayButton.transform = CGAffineTransform(translationX: 0, y: yPosition)
        }
    }
}
