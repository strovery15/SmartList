

import Foundation
import RealmSwift

protocol GetMemoTitleEntitiesUseCase {
    func execute(_ parameter: FolderEntity.ID, completion: ((Result<[MemoTitleEntity], Never>) -> ()))
}

class GetMemoTitleEntitiesInteractor: GetMemoTitleEntitiesUseCase {
    func execute(_ parameter: FolderEntity.ID, completion: ((Result<[MemoTitleEntity], Never>) -> ())) {
        let realm = try! Realm()
        let results = realm.objects(FolderEntity.self)
        let predicate = NSPredicate(format: "id == %@", parameter as CVarArg)
        if let folderEntity = results.filter(predicate).first {
            let memoTitleEntities = Array(folderEntity.memoTitles)
            completion(.success(memoTitleEntities))
        } else {
            print("error")
        }
    }
}
