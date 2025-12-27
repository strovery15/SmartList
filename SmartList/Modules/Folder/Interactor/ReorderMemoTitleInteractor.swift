

import Foundation
import RealmSwift

protocol ReorderMemoTitleUseCase {
    
    func execute(_ parameter1: FolderEntity.ID,_ parameter2: Int,_ parameter3: Int)
}

class ReorderMemoTitleInteractor: ReorderMemoTitleUseCase {
    
    func execute(_ parameter1: FolderEntity.ID,_ parameter2: Int,_ parameter3: Int) {
        let realm = try! Realm()
        let realmIdManager = realm.objects(RealmIdManagerEntity.self).first!
        var temporaryArray: [RealmMemoIdEntity] = []
        
        for (_, realmMemoId) in realmIdManager.memoIds.enumerated() {
            if realmMemoId.folderId == parameter1 {
                temporaryArray.append(realmMemoId)
            }
        }
        let sourceId = temporaryArray[parameter2]
        let destinationId = temporaryArray[parameter3]
        
        let sourceIndex = realmIdManager.memoIds.index(of: sourceId)!
        let destinationIndex = realmIdManager.memoIds.index(of: destinationId)!
        
        try! realm.write {
            realmIdManager.memoIds.move(from: sourceIndex, to: destinationIndex)
        }
    }
}
