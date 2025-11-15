

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
        
        for (index, realmMemoId) in realmIdManager.memoIds.enumerated() {
            if realmMemoId.memoId == parameter {
                let realmMemoDelete = realmMemos.first(where: { $0.id == realmMemoId.memoId })!
                try! realm.write {
                    realm.delete(realmMemoDelete)
                    realmIdManager.memoIds.remove(at: index)
                }
            }
        }
    }
}


