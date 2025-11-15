

import Foundation
import RealmSwift

protocol DeleteMemoEntityUseCase {
    
    func execute(_ parameter: MemoEntity.ID, completion: ((Result<Void, Never>) -> ()))
}

class DeleteMemoEntityInteractor: DeleteMemoEntityUseCase {
    
    func execute(_ parameter: MemoEntity.ID, completion: ((Result<Void, Never>) -> ())) {
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
        completion(.success(()))
        
    }
    
}
