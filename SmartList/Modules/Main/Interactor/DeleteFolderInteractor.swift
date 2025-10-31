

import Foundation
import RealmSwift

protocol DeleteFolderUseCase {
    
    func execute(_ parameter: FolderEntity.ID, completion: ((Result<(entities: [FolderEntity], index: Int), Never>) -> ()))
}

class DeleteFolderInteractor: DeleteFolderUseCase {
    
    func execute(_ parameter: FolderEntity.ID, completion: ((Result<(entities: [FolderEntity], index: Int), Never>) -> ())) {
        let realm = try! Realm()
        let realmFolders = realm.objects(RealmFolderEntity.self)
        let realmMemos = realm.objects(RealmMemoEntity.self)
        let realmIdManager = realm.objects(RealmIdManagerEntity.self).first!
        var firstIndex = 0
        
        let realmFolderDelete = realmFolders.first(where: { $0.id == parameter })!
        try! realm.write {
            realm.delete(realmFolderDelete)
        }
        for (index, realmFolderId) in realmIdManager.folderIds.enumerated() {
            if realmFolderId.id == parameter {
                if realmIdManager.folderIds.last!.id == realmFolderId.id {
                    firstIndex = index - 1
                } else {
                    firstIndex = index
                }
                
                try! realm.write {
                    realmIdManager.folderIds.remove(at: index)
                }
            }
        }
        
        let realmMemoDelete = realmMemos.first(where: { $0.id == parameter })!
        try! realm.write {
            realm.delete(realmMemoDelete)
        }
        for (index, realmMemoId) in realmIdManager.memoIds.enumerated() {
            if realmMemoId.folderId == parameter {
                try! realm.write {
                    realmIdManager.memoIds.remove(at: index)
                }
            }
        }
        
        var realmFoldersOrder: [RealmFolderEntity] = []
        for realmFolderId in realmIdManager.folderIds {
            let realmFolder = realmFolders.first(where: { $0.id == realmFolderId.id })!
            realmFoldersOrder.append(realmFolder)
        }
        
        var folders = objectFolders(realmFoldersOrder)
        completion(.success((folders, firstIndex)))
            
    }
    
    private func objectFolders(_ realmFolders: [RealmFolderEntity]) -> [FolderEntity] {
        var folders: [FolderEntity] = []
        for realmFolder in realmFolders {
            let folder = FolderEntity(id: realmFolder.id, name: realmFolder.name)
            folders.append(folder)
        }
        return folders
    }
}


