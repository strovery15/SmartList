

import Foundation
import RealmSwift

protocol GetMemoEntityUseCase {
    func execute(_ parameter1: FolderEntity.ID,_ parameter2: MemoEntity.ID?, completion: ((Result<(memoId: MemoEntity.ID, text: String), Never>) -> ()))
}

class GetMemoEntityInteractor: GetMemoEntityUseCase {
    
    func execute(_ parameter1: FolderEntity.ID,_ parameter2: MemoEntity.ID?, completion: ((Result<(memoId: MemoEntity.ID, text: String), Never>) -> ())) {
        
        let realm = try! Realm()
        
        if parameter2 != nil {
            let memoResults = realm.objects(MemoEntity.self)
            let memoPredicate = NSPredicate(format: "id == %@", parameter2! as CVarArg)
            if let memoEntity = memoResults.filter(memoPredicate).first {
                completion(.success((parameter2!, memoEntity.text)))
            }
        } else {
            let folderResults = realm.objects(FolderEntity.self)
            let folderPredicate = NSPredicate(format: "id == %@", parameter1 as CVarArg)
            if let folderEntity = folderResults.filter(folderPredicate).first {
                let memoEntity = MemoEntity()
                let memoTitleEntity = MemoTitleEntity()
                memoTitleEntity.id = memoEntity.id
                try! realm.write {
                    realm.add(memoEntity)
                    folderEntity.memoTitles.append(memoTitleEntity)
                }
                completion(.success((memoEntity.id, memoEntity.text)))
            }
            
        }
    }
    
}

