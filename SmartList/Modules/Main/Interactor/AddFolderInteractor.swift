

import Foundation
import RealmSwift

protocol AddFolderUseCase {
    func execute(_ parameter: String, completion: ((Result<(entities: List<FolderEntityRealm>, index: Int), Never>) -> ()))
}

class AddFolderInteractor: AddFolderUseCase {
    func execute(_ parameter: String, completion: ((Result<(entities: List<FolderEntityRealm>, index: Int), Never>) -> ())) {
        let realm = try! Realm()
        let results = realm.objects(FolderManagerEntityRealm.self)
        if let folderManager = results.first {
            var folderEntity = FolderEntityRealm()
            folderEntity.name = parameter
            try! realm.write {
                folderManager.folderEntities.append(folderEntity)
            }
            completion(.success((folderManager.folderEntities, folderManager.folderEntities.count - 1)))
        }
        
    }
    
}
