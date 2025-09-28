

import Foundation
import RealmSwift

protocol GetMemoTitlesUseCase {
    func execute(_ parameter: FolderEntity.ID, completion: ((Result<[MemoTitle], Never>) -> ()))
}

class GetMemoTitlesInteractor: GetMemoTitlesUseCase {
    func execute(_ parameter: FolderEntity.ID, completion: ((Result<[MemoTitle], Never>) -> ())) {
        let realm = try! Realm()
        let results = realm.objects(FolderEntity.self)
        let predicate = NSPredicate(format: "id == %@", parameter as CVarArg)
        if let folderEntity = results.filter(predicate).first {
            let memoTitleEntities = Array(folderEntity.memoTitles)
            var memoTitles: [MemoTitle] = []
            for memoTitleEntity in memoTitleEntities {
                let memoTitle = MemoTitle(id: memoTitleEntity.id, title: memoTitleEntity.title)
                memoTitles.append(memoTitle)
            }
            completion(.success(memoTitles))
        } else {
            print("error")
        }
    }
}
