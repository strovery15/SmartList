

import Foundation
import RealmSwift

protocol DeleteMemoTitleUseCase {
    func execute(_ parameter1: FolderEntity.ID,_ parameter2: MemoTitleEntity.ID)
}

class DeleteMemoTitleInteractor: DeleteMemoTitleUseCase {
    func execute(_ parameter1: FolderEntity.ID,_ parameter2: MemoTitleEntity.ID) {
        let realm = try! Realm()
        let results = realm.objects(FolderEntity.self)
        let predicate = NSPredicate(format: "id == %@", parameter1 as CVarArg)
        if let folderEntity = results.filter(predicate).first {
            try! realm.write {
                for (index, entity) in folderEntity.memoTitles.enumerated() {
                    if entity.id == parameter2 {
                        folderEntity.memoTitles.remove(at: index)
                    }
                }
            }
        } else {
            print("error")
        }
    }
}
