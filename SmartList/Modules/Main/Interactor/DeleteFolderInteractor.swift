

import Foundation
import RealmSwift

protocol DeleteFolderUseCase {
    func execute(_ parameter: FolderEntityRealm.ID, completion: ((Result<(entities: List<FolderEntityRealm>, index: Int), Never>) -> ()))
}

class DeleteFolderInteractor: DeleteFolderUseCase {
    func execute(_ parameter: FolderEntityRealm.ID, completion: ((Result<(entities: List<FolderEntityRealm>, index: Int), Never>) -> ())) {
        let realm = try! Realm()
        let folderManagerResults = realm.objects(FolderManagerEntityRealm.self)
        let memoResults = realm.objects(MemoEntityRealm.self)
        if let folderManager = folderManagerResults.first {
            for (index, folderEntity) in folderManager.folderEntities.enumerated() {
                if folderEntity.id == parameter {
                    for memoTitleEntity in folderEntity.memoTitles {
                        let memoPredicate = NSPredicate(format: "id == %@", memoTitleEntity.id as CVarArg)
                        if let memoEntity = memoResults.filter(memoPredicate).first {
                            try! realm.write {
                                realm.delete(memoEntity)
                            }
                        }
                    }
                    try! realm.write {
                        folderManager.folderEntities.remove(at: index)
                    }
                    completion(.success((folderManager.folderEntities, folderManager.folderEntities.count - 1)))
                }
            }
        }
            
    }
}


