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
    private var didLayoutOnce = false
    
    private let bag = DisposeBag()
    
    var selectDateSubject = BehaviorRelay<Date>(value: Date())
    var fullDaySubject = BehaviorRelay<[String]>(value: [])
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.backgroundColor = UIColor.clear
        
        if !didLayoutOnce {
            didLayoutOnce = true
            collectionView.dataSource = nil
            collectionView.delegate = nil
            bind()
        }
    }
    
    func bind() {
        collectionView.rx.setDelegate(self)
            .disposed(by: bag)
        
        fullDaySubject
            .asDriver(onErrorJustReturn: [])
            .drive(collectionView.rx.items(cellIdentifier: CalendarCell.reuseIdentifier, cellType: CalendarCell.self)){row, element, cell in
                cell.dayOfMonth.text = element
            }
            .disposed(by: bag)
        
        nextButton.rx.tap
            .withUnretained(self)
            .flatMap({ (owner, _) in
              CalendarHelper.shared.plusMonth(date: owner.selectDateSubject.value)
            })
            .bind(to: selectDateSubject)
            .disposed(by: bag)
        
        prevButton.rx.tap
            .withUnretained(self)
            .flatMap({ (owner, _) in
                CalendarHelper.shared.minusMonth(date: owner.selectDateSubject.value)
            })
            .bind(to: selectDateSubject)
            .disposed(by: bag)
        
        selectDateSubject
            .flatMap { CalendarHelper.shared.makeMonth(date: $0) }
            .bind(to: fullDaySubject)
            .disposed(by: bag)
        
        selectDateSubject
            .map { $0.toDateAndMonthString }
            .asDriver(onErrorJustReturn: "")
            .drive(monthLabel.rx.text)
            .disposed(by: bag)
        
    }
}

extension CustomCalendar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let value = (collectionView.frame.size.width - 2) / 9
        return CGSize(width: value, height: 30)
    }
}
