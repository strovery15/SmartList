

import RealmSwift

protocol GetFoldersUseCase {
    func execute(completion: ((Result<(entities: Results<FolderEntityRealm>, index: Int), Never>) -> ()))
}

class GetFoldersInteractor: GetFoldersUseCase {
    func execute(completion: ((Result<(entities: RealmSwift.Results<FolderEntityRealm>, index: Int), Never>) -> ())) {
        let realm = try! Realm()
        let results = realm.objects(FolderEntityRealm.self)
        completion(.success((results, 0)))
    }
    
}
