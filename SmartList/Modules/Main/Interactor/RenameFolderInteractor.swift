

import Foundation
import RealmSwift

protocol RenameFolderUseCase {
    func execute(_ parameter1: FolderEntityRealm.ID,_ parameter2: String, completion: ((Result<(entities: List<FolderEntityRealm>, index: Int), Never>) -> ()))
}

class RenameFolderInteractor: RenameFolderUseCase {
    func execute(_ parameter1: FolderEntityRealm.ID, _ parameter2: String, completion: ((Result<(entities: List<FolderEntityRealm>, index: Int), Never>) -> ())) {
        
        let realm = try! Realm()
        let results = realm.objects(FolderManagerEntityRealm.self)
        if let folderManager = results.first {
            for (index, folderEntity) in folderManager.folderEntities.enumerated() {
                if folderEntity.id == parameter1 {
                    try! realm.write {
                        folderManager.folderEntities[index].name = parameter2
                    }
                    completion(.success((folderManager.folderEntities, index)))
                }
            }
        }
    }
    
}
