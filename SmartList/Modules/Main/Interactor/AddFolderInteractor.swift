

import Foundation
import RealmSwift

protocol AddFolderUseCase {
    func execute(_ parameter: String, completion: ((Result<(entities: Results<FolderEntityRealm>, index: Int), Never>) -> ()))
}

class AddFolderInteractor: AddFolderUseCase {
    func execute(_ parameter: String, completion: ((Result<(entities: RealmSwift.Results<FolderEntityRealm>, index: Int), Never>) -> ())) {
        let realm = try! Realm()
        let results = realm.objects(FolderEntityRealm.self)
        var folderEntity = FolderEntityRealm()
        folderEntity.name = parameter
        try! realm.write {
            realm.add(folderEntity)
        }
        completion(.success((results, results.count - 1)))
    }
    
}
