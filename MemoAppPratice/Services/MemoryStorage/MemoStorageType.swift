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
    func createMemo(memo: Memo) -> Observable<Void>
    @discardableResult
    func updateMemo(memo: Memo) -> Observable<Void>
    @discardableResult
    func deleteMemo(memo: Memo) -> Observable<Void>
    @discardableResult
    func fetchMemos() -> Observable<[Memo]>
}
