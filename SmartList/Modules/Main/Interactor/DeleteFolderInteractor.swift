

import Foundation
import RealmSwift

protocol DeleteFolderUseCase {
    func execute(_ parameter: FolderEntity.ID, completion: ((Result<Void, Never>) -> ()))
}

class DeleteFolderInteractor: DeleteFolderUseCase {
    func execute(_ parameter: FolderEntity.ID, completion: ((Result<Void, Never>) -> ())) {
        let realm = try! Realm()
        let folderResults = realm.objects(FolderEntity.self)
        let memoResults = realm.objects(MemoEntity.self)
        let folderPredicate = NSPredicate(format: "id == %@", parameter as CVarArg)
        if let folderEntity = folderResults.filter(folderPredicate).first {
            let memoTitleEntities = Array(folderEntity.memoTitles)
            for memoTitleEntity in memoTitleEntities {
                let memoPredicate = NSPredicate(format: "id == %@", memoTitleEntity.id as CVarArg)
                if let memoEntity = memoResults.filter(memoPredicate).first {
                    try! realm.write {
                        realm.delete(memoEntity)
                    }
                }
            }
            try! realm.write {
                realm.delete(folderEntity)
                completion(.success(()))
            }
        }
    }
}


