

import RealmSwift

protocol GetFolderEntitiesUseCase {
    func execute(completion: ((Result<[FolderEntity], Never>) -> ())?)
}

class GetFolderEntitiesInteractor: GetFolderEntitiesUseCase {
    let realm = try! Realm()
    
    func execute(completion: ((Result<[FolderEntity], Never>) -> ())?) {
        var folderEntities: [FolderEntity] = []
        let results = realm.objects(FolderEntity.self)
        folderEntities = Array(results)
        completion?(.success(folderEntities))
    }
    
}
