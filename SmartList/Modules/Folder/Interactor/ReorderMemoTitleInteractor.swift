

import Foundation
import RealmSwift

protocol ReorderMemoTitleUseCase {
    func execute(_ parameter1: FolderEntity.ID,_ parameter2: CollectionDifference<MemoTitleEntity.ID>)
}

class ReorderMemoTitleInteractor: ReorderMemoTitleUseCase {
    func execute(_ parameter1: FolderEntity.ID,_ parameter2: CollectionDifference<MemoTitleEntity.ID>) {
        
        let realm = try! Realm()
        let results = realm.objects(FolderEntity.self)
        let predicate = NSPredicate(format: "id == %@", parameter1 as CVarArg)
        if let folderEntity = results.filter(predicate).first {
            try! realm.write {
                var sourceIndex = 0
                var destinationIndex = 0
                for change in parameter2 {
                    switch change {
                    case .insert(offset: let offset,_,_):
                        destinationIndex = offset
                    case .remove(offset: let offset,_,_):
                        sourceIndex = offset
                    }
                }
                folderEntity.memoTitles.move(from: sourceIndex, to: destinationIndex)
            }
        } else {
            print("error")
        }
    }
}
