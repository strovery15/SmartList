

import RealmSwift

class GetFolderEntitiesUseCase: UseCaseProtocol {
    
    func execute(_ parameter: Void, completion: ((Result<[FolderEntity], Never>) -> ())?) {
        let realm = try! Realm()
        var folderEntities: [FolderEntity] = []
        let results = realm.objects(FolderEntity.self)
        folderEntities = Array(results)
        completion?(.success(folderEntities))
    }
}
