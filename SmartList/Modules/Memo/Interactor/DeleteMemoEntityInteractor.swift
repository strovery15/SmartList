

import Foundation
import RealmSwift

protocol DeleteMemoEntityUseCase {
    func execute(_ parameter1: FolderEntityRealm.ID,_ parameter2: MemoEntityRealm.ID, completion: ((Result<Void, Never>) -> ()))
}

class DeleteMemoEntityInteractor: DeleteMemoEntityUseCase {
    
    func execute(_ parameter1: FolderEntityRealm.ID, _ parameter2: MemoEntityRealm.ID, completion: ((Result<Void, Never>) -> ())) {
        let realm = try! Realm()
        let folderResults = realm.objects(FolderEntityRealm.self)
        let memoResults = realm.objects(MemoEntityRealm.self)
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
            completion(.success(()))
        } else {
            print("error")
        }
    }
    
}
