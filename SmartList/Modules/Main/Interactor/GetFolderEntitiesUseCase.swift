

import RealmSwift

class GetFolderEntitiesUseCase: UseCaseProtocol {
    let realm = try! Realm()
    
    func execute(_ parameter: Void, completion: ((Result<[FolderEntity], Never>) -> ())?) {
        var folderEntities: [FolderEntity] = []
        let results = realm.objects(FolderEntity.self)
        folderEntities = Array(results)
        completion?(.success(folderEntities))
    }
}
