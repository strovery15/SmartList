

import Foundation
import RealmSwift

protocol DeleteFolderUseCase {
    func execute(_ parameter: FolderEntity.ID, completion: ((Result<Void, Never>) -> ()))
}

class DeleteFolderInteractor: DeleteFolderUseCase {
    func execute(_ parameter: FolderEntity.ID, completion: ((Result<Void, Never>) -> ())) {
        let realm = try! Realm()
        let results = realm.objects(FolderEntity.self)
        let predicate = NSPredicate(format: "id == %@", parameter as CVarArg)
        if let folderEntity = results.filter(predicate).first {
            try! realm.write {
                realm.delete(folderEntity)
                completion(.success(()))
            }
        }
    }
}
