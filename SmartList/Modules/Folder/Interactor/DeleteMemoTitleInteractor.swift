

import Foundation
import RealmSwift

protocol DeleteMemoTitleUseCase {
    
    func execute(_ parameter: MemoEntity.ID)
}

class DeleteMemoTitleInteractor: DeleteMemoTitleUseCase {
    
    func execute(_ parameter: MemoEntity.ID) {
        let realm = try! Realm()
        let realmMemos = realm.objects(RealmMemoEntity.self)
        let realmIdManager = realm.objects(RealmIdManagerEntity.self).first!
        
        let realmMemoDelete = realmMemos.first(where: { $0.id == parameter })!
        try! realm.write {
            realm.delete(realmMemoDelete)
        }
        for (index, realmMemoId) in realmIdManager.memoIds.enumerated() {
            if realmMemoId.memoId == parameter {
                try! realm.write {
                    realmIdManager.memoIds.remove(at: index)
                }
            }
        }
    }
}


