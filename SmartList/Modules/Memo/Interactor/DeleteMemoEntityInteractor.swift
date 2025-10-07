

import Foundation
import RealmSwift

protocol DeleteMemoEntityUseCase {
    func execute(_ parameter1: FolderEntityRealm.ID,_ parameter2: MemoEntityRealm.ID, completion: ((Result<Void, Never>) -> ()))
}

class DeleteMemoEntityInteractor: DeleteMemoEntityUseCase {
    
    func execute(_ parameter1: FolderEntityRealm.ID, _ parameter2: MemoEntityRealm.ID, completion: ((Result<Void, Never>) -> ())) {
        let realm = try! Realm()
        let folderManagerResults = realm.objects(FolderManagerEntityRealm.self)
        let memoResults = realm.objects(MemoEntityRealm.self)
        let memoPredicate = NSPredicate(format: "id == %@", parameter2 as CVarArg)
        if let folderManager = folderManagerResults.first {
            for (index, folderEntity) in folderManager.folderEntities.enumerated() {
                if folderEntity.id == parameter1 {
                    if let memoEntity = memoResults.filter(memoPredicate).first {
                        for (index, memoTitleEntity) in folderEntity.memoTitles.enumerated() {
                            if memoTitleEntity.id == parameter2 {
                                try! realm.write {
                                    folderEntity.memoTitles.remove(at: index)
                                    realm.delete(memoEntity)
                                }
                            }
                        }
                    }
                    completion(.success(()))
                }
            }
        }
    }
    
}
