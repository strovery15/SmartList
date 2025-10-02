

import Foundation
import RealmSwift

protocol ReorderMemoTitleUseCase {
    func execute(_ parameter1: FolderEntityRealm.ID,_ parameter2: Int,_ parameter3: Int)
}

class ReorderMemoTitleInteractor: ReorderMemoTitleUseCase {
    func execute(_ parameter1: FolderEntityRealm.ID,_ parameter2: Int,_ parameter3: Int) {
        let realm = try! Realm()
        let results = realm.objects(FolderEntityRealm.self)
        let predicate = NSPredicate(format: "id == %@", parameter1 as CVarArg)
        if let folderEntity = results.filter(predicate).first {
            try! realm.write {
                folderEntity.memoTitles.move(from: parameter2, to: parameter3)
            }
        } else {
            print("error")
        }
    }
}
