

import Foundation
import RealmSwift

protocol GetMemoEntityUseCase {
    func execute(_ parameter1: FolderEntityRealm.ID,_ parameter2: MemoEntityRealm.ID?, completion: ((Result<(memoId: MemoEntityRealm.ID, text: String), Never>) -> ()))
}

class GetMemoEntityInteractor: GetMemoEntityUseCase {
    
    func execute(_ parameter1: FolderEntityRealm.ID,_ parameter2: MemoEntityRealm.ID?, completion: ((Result<(memoId: MemoEntityRealm.ID, text: String), Never>) -> ())) {
        
        let realm = try! Realm()
        
        if parameter2 != nil {
            let memoResults = realm.objects(MemoEntityRealm.self)
            let memoPredicate = NSPredicate(format: "id == %@", parameter2! as CVarArg)
            if let memoEntity = memoResults.filter(memoPredicate).first {
                completion(.success((parameter2!, memoEntity.text)))
            }
        } else {
            let folderManagerResults = realm.objects(FolderManagerEntityRealm.self)
            if let folderManager = folderManagerResults.first {
                for (index, folderEntity) in folderManager.folderEntities.enumerated() {
                    if folderEntity.id == parameter1 {
                        let memoEntity = MemoEntityRealm()
                        let memoTitleEntity = MemoTitleEntityRealm()
                        memoTitleEntity.id = memoEntity.id
                        try! realm.write {
                            realm.add(memoEntity)
                            folderEntity.memoTitles.insert(memoTitleEntity, at: 0)
                        }
                        completion(.success((memoEntity.id, memoEntity.text)))
                    }
                }
            }
        }
    }
}


