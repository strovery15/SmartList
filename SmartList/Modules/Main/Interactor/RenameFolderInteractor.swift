

import Foundation
import RealmSwift

protocol RenameFolderUseCase {
    
    func execute(_ parameter1: FolderEntity.ID,_ parameter2: String, completion: ((Result<(entities: [FolderEntity], index: Int), Never>) -> ()))
}

class RenameFolderInteractor: RenameFolderUseCase {
    
    func execute(_ parameter1: FolderEntity.ID, _ parameter2: String, completion: ((Result<(entities: [FolderEntity], index: Int), Never>) -> ())) {
        
        let realm = try! Realm()
        let realmFolders = realm.objects(RealmFolderEntity.self)
        let realmIdManager = realm.objects(RealmIdManagerEntity.self).first!
        var firstIndex = 0
        
        for (index, realmFolderId) in realmIdManager.folderIds.enumerated() {
            if realmFolderId.id == parameter1 {
                firstIndex = index
                
                let realmFolderRename = realmFolders.first(where: { $0.id == realmFolderId.id })
                try! realm.write {
                    realmFolderRename?.name = parameter2
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
