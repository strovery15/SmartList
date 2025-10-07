

import RealmSwift

protocol GetFoldersUseCase {
    func execute(completion: ((Result<(entities: List<FolderEntityRealm>, index: Int), Never>) -> ()))
}

class GetFoldersInteractor: GetFoldersUseCase {
    func execute(completion: ((Result<(entities: List<FolderEntityRealm>, index: Int), Never>) -> ())) {
        let realm = try! Realm()
        let results = realm.objects(FolderManagerEntityRealm.self)
        if let folderManager = results.first {
            completion(.success((folderManager.folderEntities, 0)))
        }
        
    }
    
}
