//
//  MainPageViewModel.swift
//  MemoAppPratice
//
//  Created by 석기권 on 6/24/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MainPageViewModel: ViewModelType {
    struct Input {
        let settingButtonTap: ControlEvent<Void>
    }
    struct Output {
        let goToSettingVC: Observable<Void>
    }
    
    func transform(input: Input) -> Output {
        return Output(goToSettingVC: input.settingButtonTap.asObservable())
    }
}
