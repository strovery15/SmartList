

import Foundation
import RealmSwift

protocol DeleteMemoTitleUseCase {
    func execute(_ parameter1: FolderEntity.ID,_ parameter2: MemoTitleEntity.ID)
}

class DeleteMemoTitleInteractor: DeleteMemoTitleUseCase {
    func execute(_ parameter1: FolderEntity.ID,_ parameter2: MemoTitleEntity.ID) {
        let realm = try! Realm()
        let folderResults = realm.objects(FolderEntity.self)
        let memoResults = realm.objects(MemoEntity.self)
        let folderPredicate = NSPredicate(format: "id == %@", parameter1 as CVarArg)
        let memoPredicate = NSPredicate(format: "id == %@", parameter2 as CVarArg)
        if let folderEntity = folderResults.filter(folderPredicate).first {
            if let memoEntity = memoResults.filter(memoPredicate).first {
                for (index, entity) in folderEntity.memoTitles.enumerated() {
                    if entity.id == parameter2 {
                        try! realm.write {
                            folderEntity.memoTitles.remove(at: index)
                            realm.delete(memoEntity)
                        }
                        
                    }
                }
            }
        } else {
            print("error")
        }
    }
}


