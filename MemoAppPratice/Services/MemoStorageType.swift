//
//  MemoStorageType.swift
//  MemoAppPratice
//
//  Created by 석기권 on 6/17/24.
//

import Foundation
import RxSwift

protocol MemoStorageType {
    @discardableResult
    func updateMemo(memo: Memo) -> Observable<Memo>
    @discardableResult
    func deleteMemo(memo: Memo) -> Observable<Void>
    @discardableResult
    func getAllMemo() -> Observable<[Memo]>
}
