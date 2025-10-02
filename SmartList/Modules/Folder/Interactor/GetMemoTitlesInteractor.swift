

import Foundation
import RealmSwift

protocol GetMemoTitlesUseCase {
    func execute(_ parameter: FolderEntityRealm.ID, completion: ((Result<[MemoTitleEntity], Never>) -> ()))
}

class GetMemoTitlesInteractor: GetMemoTitlesUseCase {
    func execute(_ parameter: FolderEntityRealm.ID, completion: ((Result<[MemoTitleEntity], Never>) -> ())) {
        let realm = try! Realm()
        let results = realm.objects(FolderEntityRealm.self)
        let predicate = NSPredicate(format: "id == %@", parameter as CVarArg)
        if let folderEntity = results.filter(predicate).first {
            var memoTitleEntities: [MemoTitleEntity] = []
            for memoTitle in folderEntity.memoTitles {
                let memoTitleEntity = MemoTitleEntity(id: memoTitle.id, title: memoTitle.title)
                memoTitleEntities.append(memoTitleEntity)
            }
            completion(.success(memoTitleEntities))
        } else {
            print("error")
        }
    }
}
