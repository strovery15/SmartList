

import RealmSwift

protocol GetFoldersUseCase {
    
    func execute(completion: ((Result<(entities: [FolderEntity], index: Int), Never>) -> ()))
}

class GetFoldersInteractor: GetFoldersUseCase {
    
    func execute(completion: ((Result<(entities: [FolderEntity], index: Int), Never>) -> ())) {
        let realm = try! Realm()
        let realmFolders = realm.objects(RealmFolderEntity.self)
        let realmIdManager = realm.objects(RealmIdManagerEntity.self).first!
        
        var realmFoldersOrder: [RealmFolderEntity] = []
        for realmFolderId in realmIdManager.folderIds {
            let realmFolder = realmFolders.first(where: { $0.id == realmFolderId.id })!
            realmFoldersOrder.append(realmFolder)
        }
        
        var folders = objectFolders(realmFoldersOrder)
        completion(.success((folders, 0)))
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
