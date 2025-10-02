

import Foundation
import RealmSwift

protocol AddFolderUseCase {
    func execute(_ parameter: String, completion: ((Result<Void, Never>) -> ()))
}

class AddFolderInteractor: AddFolderUseCase {
    func execute(_ parameter: String, completion: ((Result<Void, Never>) -> ())) {
        let realm = try! Realm()
        var folderEntity = FolderEntityRealm()
        folderEntity.name = parameter
        try! realm.write {
            realm.add(folderEntity)
        }
        completion(.success(()))
    }
}
