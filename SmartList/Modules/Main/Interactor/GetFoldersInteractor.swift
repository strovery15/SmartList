

import RealmSwift

protocol GetFoldersUseCase {
    func execute(completion: ((Result<[FolderEntity], Never>) -> ()))
}

class GetFoldersInteractor: GetFoldersUseCase {
    
    func execute(completion: ((Result<[FolderEntity], Never>) -> ())) {
        let realm = try! Realm()
        var folderEntities: [FolderEntity] = []
        let results = realm.objects(FolderEntity.self)
        folderEntities = Array(results)
        completion(.success(folderEntities))
    }
}
