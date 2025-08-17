

import Foundation
import RealmSwift

class AddFolderEntityUseCase: UseCaseProtocol {
    func execute(_ parameter: String, completion: ((Result<Void, Never>) -> ())?) {
        let realm = try! Realm()
        var newFolderEntity = FolderEntity()
        newFolderEntity.name = parameter
        try! realm.write {
            realm.add(newFolderEntity)
        }
        completion?(.success(()))
    }
}
