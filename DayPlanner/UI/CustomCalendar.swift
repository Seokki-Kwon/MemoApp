//
//  CustomCalendar.swift
//  DayPlanner
//
//  Created by 석기권 on 6/28/24.
//

import UIKit
import RxSwift
import RxCocoa

class CustomCalendar: UIView {
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    
    private let bag = DisposeBag()
    private let calendarHelper = CalendarHelper.shared
    
    var dateSubject = BehaviorRelay<Date>(value: Date())
    var daySubject = BehaviorSubject<[String]>(value: [])
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.dataSource = nil
        collectionView.delegate = nil
        bind()
    }
    
    func bind() {
        calendarHelper.makeMonth(date: dateSubject.value)
            .take(1)
            .bind(to: daySubject)
            .disposed(by: bag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: bag)
        
        daySubject
            .asDriver(onErrorJustReturn: [])
            .drive(collectionView.rx.items(cellIdentifier: CalendarCell.reuseIdentifier, cellType: CalendarCell.self)){row, element, cell in
                cell.dayOfMonth.text = element
            }
            .disposed(by: bag)
            
       nextButton.rx.tap
            .withUnretained(self)
            .map({ (owner, _) in
                owner.calendarHelper.plusMonth(date: owner.dateSubject.value)
            })
            .flatMap { $0 }
            .bind(to: dateSubject)
            .disposed(by: bag)
        
        
    }
}

extension CustomCalendar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let value = (collectionView.frame.size.width - 2) / 9
        return CGSize(width: value, height: value)
    }
}
