

import RealmSwift

protocol GetFoldersUseCase {
    func execute(completion: ((Result<Results<FolderEntityRealm>, Never>) -> ()))
}

class GetFoldersInteractor: GetFoldersUseCase {
    
    func execute(completion: ((Result<Results<FolderEntityRealm>, Never>) -> ())) {
        let realm = try! Realm()
        let results = realm.objects(FolderEntityRealm.self)
        completion(.success(results))
    }
}
