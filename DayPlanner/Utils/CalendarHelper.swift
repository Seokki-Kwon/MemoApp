//
//  CalendarHelper.swift
//  DayPlanner
//
//  Created by 석기권 on 6/28/24.
//

import UIKit
import RxSwift

final class CalendarHelper {
    static let shared = CalendarHelper()
    private init() {}
    let calendar = Calendar.current
    
    func plusMonth(date: Date) -> Observable<Date> {
        return Observable.just(calendar.date(byAdding: .month, value: 1, to: date)!)
    }
    
    func minusMonth(date: Date) -> Observable<Date> {
        return Observable.just(calendar.date(byAdding: .month, value: -1, to: date)!)
    }
    
    func monthString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: date)
    }
    
    func yearString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }
    
    /// 달의 마지막을 출력합니다 29, 30, 31
    func daysInMonth(date: Date) -> Int {
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    /// 현재 날짜
    func daysOfMonth(date: Date) -> Int {
        let componets = calendar.dateComponents([.day], from: date)
        return componets.day!
    }
    
    /// 현재 달의 첫번째 날에대한 정보
    func firstOfMonth(date: Date) -> Date {
        
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }
    
    /// 요일 1-7
    func weekDay(date: Date) -> Int {
        let components = calendar.dateComponents([.weekday], from: date)        
        return components.weekday! - 1
    }
    
    func makeMonth(date: Date) -> Observable<[Day]> {
        let daysInMonth = daysInMonth(date: date)
        let firstDayOfMonth = firstOfMonth(date: date)
        let startingSpace = weekDay(date: firstDayOfMonth)
            
        var count: Int = 1
        var days: [Day] = []
        while(count <= 42) {
            if (count <= startingSpace || count - startingSpace > daysInMonth) {
                days.append(Day(dayOfMonth: ""))
            }
            else {
                days.append(Day(dayOfMonth: "\(count - startingSpace)"))
            }
            count += 1
        }
        
        return Observable.just(days)
    }
}
