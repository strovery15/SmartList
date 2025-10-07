

import Foundation
import RealmSwift

protocol ReorderMemoTitleUseCase {
    func execute(_ parameter1: FolderEntityRealm.ID,_ parameter2: Int,_ parameter3: Int)
}

class ReorderMemoTitleInteractor: ReorderMemoTitleUseCase {
    func execute(_ parameter1: FolderEntityRealm.ID,_ parameter2: Int,_ parameter3: Int) {
        let realm = try! Realm()
        let results = realm.objects(FolderManagerEntityRealm.self)
        if let folderManager = results.first {
            for (index, folderEntity) in folderManager.folderEntities.enumerated() {
                if folderEntity.id == parameter1 {
                    try! realm.write {
                        folderEntity.memoTitles.move(from: parameter2, to: parameter3)
                    }
                }
            }
        }
    }
}
