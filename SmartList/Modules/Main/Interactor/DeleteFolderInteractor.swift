

import Foundation
import RealmSwift

protocol DeleteFolderUseCase {
    func execute(_ parameter: FolderEntityRealm.ID, completion: ((Result<(entities: Results<FolderEntityRealm>, index: Int), Never>) -> ()))
}

class DeleteFolderInteractor: DeleteFolderUseCase {
    func execute(_ parameter: FolderEntityRealm.ID, completion: ((Result<(entities: Results<FolderEntityRealm>, index: Int), Never>) -> ())) {
        let realm = try! Realm()
        let folderResults = realm.objects(FolderEntityRealm.self)
        let memoResults = realm.objects(MemoEntityRealm.self)
        let folderPredicate = NSPredicate(format: "id == %@", parameter as CVarArg)
        if let folderEntity = folderResults.filter(folderPredicate).first {
            for memoTitleEntity in folderEntity.memoTitles {
                let memoPredicate = NSPredicate(format: "id == %@", memoTitleEntity.id as CVarArg)
                if let memoEntity = memoResults.filter(memoPredicate).first {
                    try! realm.write {
                        realm.delete(memoEntity)
                    }
                }
            }
            try! realm.write {
                realm.delete(folderEntity)
            }
            completion(.success((folderResults, folderResults.count - 1)))
        }
    }
}


