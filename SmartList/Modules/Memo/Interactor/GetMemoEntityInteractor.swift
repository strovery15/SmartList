

import Foundation
import RealmSwift

protocol GetMemoEntityUseCase {
    
    func execute(_ parameter1: FolderEntity.ID,_ parameter2: MemoEntity.ID?, completion: ((Result<(memoId: MemoEntity.ID, text: String), Never>) -> ()))
}

class GetMemoEntityInteractor: GetMemoEntityUseCase {
    
    func execute(_ parameter1: FolderEntity.ID,_ parameter2: MemoEntity.ID?, completion: ((Result<(memoId: MemoEntity.ID, text: String), Never>) -> ())) {
        let realm = try! Realm()
        let realmMemos = realm.objects(RealmMemoEntity.self)
        let realmIdManager = realm.objects(RealmIdManagerEntity.self).first!
        
        if parameter2 != nil {
            let realmMemo = realmMemos.first(where: { $0.id == parameter2 })!
            var memo = objectMemo(realmMemo)
            completion(.success((memo.id, memo.memo)))
        } else {
            let realmMemoAdd = RealmMemoEntity()
            let realmMemoIdAdd = RealmMemoIdEntity()
            realmMemoIdAdd.folderId = parameter1
            realmMemoIdAdd.memoId = realmMemoAdd.id
            
            try! realm.write {
                realm.add(realmMemoAdd)
                realmIdManager.memoIds.insert(realmMemoIdAdd, at: 0)
            }
            var memoAdd = objectMemo(realmMemoAdd)
            completion(.success((memoAdd.id, memoAdd.memo)))
        }
    }
    
    private func objectMemo(_ realmMemo: RealmMemoEntity) -> MemoEntity {
        var memo = MemoEntity(id: realmMemo.id, memo: realmMemo.memo)
        return memo
    }
}


