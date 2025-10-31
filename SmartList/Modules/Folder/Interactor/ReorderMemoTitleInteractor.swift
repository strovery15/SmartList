

import Foundation
import RealmSwift

protocol ReorderMemoTitleUseCase {
    
    func execute(_ parameter1: MemoEntity.ID,_ parameter2: MemoEntity.ID)
}

class ReorderMemoTitleInteractor: ReorderMemoTitleUseCase {
    
    func execute(_ parameter1: MemoEntity.ID,_ parameter2: MemoEntity.ID) {
        let realm = try! Realm()
        let realmIdManager = realm.objects(RealmIdManagerEntity.self).first!
        var deleteIndex = 0
        var insertIndex = 0
        var insertItem: RealmMemoIdEntity?
        
        for (index, realmMemoId) in realmIdManager.memoIds.enumerated() {
            if realmMemoId.memoId == parameter1 {
                deleteIndex = index
                insertItem = realmMemoId
            }
            if realmMemoId.memoId == parameter2 {
                insertIndex = index
            }
        }
        
        try! realm.write {
            realmIdManager.memoIds.remove(at: deleteIndex)
            realmIdManager.memoIds.insert(insertItem!, at: insertIndex)
        }
    }
}
