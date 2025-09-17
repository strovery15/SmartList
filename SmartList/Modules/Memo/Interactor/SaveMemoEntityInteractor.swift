

import Foundation
import RealmSwift

protocol SaveMemoEntityUseCase {
    func execute(_ parameter1: FolderEntity.ID,_ parameter2: MemoEntity.ID, _ parameter3: String)
}

class SaveMemoEntityInteractor: SaveMemoEntityUseCase {
    
    func execute(_ parameter1: FolderEntity.ID, _ parameter2: MemoEntity.ID, _ parameter3: String) {
        let realm = try! Realm()
        let folderResults = realm.objects(FolderEntity.self)
        let memoResults = realm.objects(MemoEntity.self)
        let folderPredicate = NSPredicate(format: "id == %@", parameter1 as CVarArg)
        let memoPredicate = NSPredicate(format: "id == %@", parameter2 as CVarArg)
        
        if let folderEntity = folderResults.filter(folderPredicate).first {
            for (index, memoTitleEntity) in folderEntity.memoTitles.enumerated() {
                if memoTitleEntity.id == parameter2 {
                    try! realm.write {
                        memoTitleEntity.title = parameter3
                    }
                }
            }
            
        } else {
            print("error")
        }
        if let memoEntity = memoResults.filter(memoPredicate).first {
            try! realm.write {
                memoEntity.text = parameter3
            }
        } else {
            print("error")
        }
    }
    
}


