//
//  MainPageViewModel.swift
//  MemoAppPratice
//
//  Created by 석기권 on 6/24/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MainViewModel: ViewModelType {
    struct Input {
        let settingButtonTap: ControlEvent<Void>
        let segmentSeleted: ControlProperty<Int>
    }
    struct Output {
        let goToSettingVC: Observable<Void>
        let movePage: Driver<Int>        
    }
    
    func transform(input: Input) -> Output {
        return Output(goToSettingVC: input.settingButtonTap.asObservable(),movePage: input.segmentSeleted.asDriver())
    }
}
