

import Foundation
import RealmSwift

protocol AddFolderUseCase {
    
    func execute(_ parameter: String, completion: ((Result<(entities: [FolderEntity], index: Int), Never>) -> ()))
}

class AddFolderInteractor: AddFolderUseCase {
    
    func execute(_ parameter: String, completion: ((Result<(entities: [FolderEntity], index: Int), Never>) -> ())) {
        let realm = try! Realm()
        let realmFolders = realm.objects(RealmFolderEntity.self)
        let realmIdManager = realm.objects(RealmIdManagerEntity.self).first!
        
        let realmFolderAdd = RealmFolderEntity()
        realmFolderAdd.name = parameter
        let realmFolderIdAdd = RealmFolderIdEntity()
        realmFolderIdAdd.id = realmFolderAdd.id
        
        try! realm.write {
            realm.add(realmFolderAdd)
            realmIdManager.folderIds.append(realmFolderIdAdd)
        }
        
        var realmFoldersOrder: [RealmFolderEntity] = []
        for realmFolderId in realmIdManager.folderIds {
            let realmFolder = realmFolders.first(where: { $0.id == realmFolderId.id })!
            realmFoldersOrder.append(realmFolder)
        }
        
        var folders = objectFolders(realmFoldersOrder)
        completion(.success((folders, folders.count - 1)))
        
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
