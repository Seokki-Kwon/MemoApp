//
//  CoreDataStorage.swift
//  MemoAppPratice
//
//  Created by 석기권 on 6/21/24.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData

final class CoreDataStorage: MemoStorageType {
    
    
    let modelName: String
    private let store = BehaviorSubject<[Memo]>(value: [])
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    // container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // context
    private var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    /// 메모 추가
    @discardableResult
    func createMemo(memo: Memo) -> RxSwift.Observable<Void> {
        guard let entity = NSEntityDescription.entity(forEntityName: "Memo", in: mainContext) else {
            return Observable.empty()
        }
        
        let memoObject = NSManagedObject(entity: entity, insertInto: mainContext)
        memoObject.setValue(memo.id, forKey: "id")
        memoObject.setValue(memo.title, forKey: "title")
        memoObject.setValue(memo.content, forKey: "content")
        memoObject.setValue(memo.date, forKey: "date")
        
        do {
            _ = try mainContext.save()
            let currentData = try store.value()
            store.onNext(currentData + [memo])
            return Observable.just(())
        } catch {
            return Observable.error(error)
        }
    }
    
    /// 메모 업데이트(제목, 내용)
    @discardableResult
    func updateMemo(memo: Memo) -> RxSwift.Observable<Void> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Memo")
        fetchRequest.predicate = NSPredicate(format: "id == %@", memo.id as CVarArg)
        
        do {
            if let fetchRequest = try mainContext.fetch(fetchRequest) as? [NSManagedObject],
               let memoObject = fetchRequest.first {                
                memoObject.setValue(memo.id, forKey: "id")
                memoObject.setValue(memo.title, forKey: "title")
                memoObject.setValue(memo.content, forKey: "content")
                memoObject.setValue(memo.date, forKey: "date")
                
                do {
                    _ = try mainContext.save()
                    let updated = try store.value().map { $0.id == memo.id ? memo : $0 }
                    store.onNext(updated)
                } catch {
                    return Observable.error(error)
                }
                
            } else {
                return createMemo(memo: memo)
            }
            
            return Observable.just(())
        } catch {
            return Observable.error(error)
        }
    }
    
    /// 메모 삭제
    @discardableResult
    func deleteMemo(memo: Memo) -> RxSwift.Observable<Void> {
        // NSFetchRequest CoreData에서 검색을 하기위함
        // NSPredicate NSArray를 필터링
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Memo")
        fetchRequest.predicate = NSPredicate(format: "id == %@", memo.id as CVarArg)
        
        do {
            if let fetchRequest = try mainContext.fetch(fetchRequest) as? [NSManagedObject],
               let memoObject = fetchRequest.first {
                mainContext.delete(memoObject)
                try mainContext.save()
                let updated = try store.value().filter { $0.id != memo.id }
                store.onNext(updated)
                return Observable.just(())
            }
        } catch {
            return Observable.error(error)
        }
        return Observable.just(())
    }
    
    /// 메모 가져오기
    @discardableResult
    func fetchMemos() -> RxSwift.Observable<[Memo]> {
        do {
            let data = try mainContext.fetch(MemoEntity.fetchRequest())
            let memoDatas = data.map { Memo(id: $0.id!, title: $0.title!, content: $0.content! )}
            store.onNext(memoDatas)
            return store
        } catch {
            return Observable.error(error)
        }
    }
}
