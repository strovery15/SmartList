

import Foundation
import RealmSwift

protocol GetMemoTitlesUseCase {
    func execute(_ parameter: FolderEntityRealm.ID, completion: ((Result<[MemoTitleEntity], Never>) -> ()))
}

class GetMemoTitlesInteractor: GetMemoTitlesUseCase {
    func execute(_ parameter: FolderEntityRealm.ID, completion: ((Result<[MemoTitleEntity], Never>) -> ())) {
        let realm = try! Realm()
        var memoTitleEntities: [MemoTitleEntity] = []
        let results = realm.objects(FolderManagerEntityRealm.self)
        if let folderManager = results.first {
            for (index, folderEntity) in folderManager.folderEntities.enumerated() {
                if folderEntity.id == parameter {
                    for memoTitle in folderEntity.memoTitles {
                        let memoTitleEntity = MemoTitleEntity(id: memoTitle.id, title: memoTitle.title)
                        memoTitleEntities.append(memoTitleEntity)
                    }
                    completion(.success(memoTitleEntities))
                }
            }
        }
    }
}
