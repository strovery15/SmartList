

import Foundation
import TabPageViewController
import RealmSwift

protocol MainPresentation: AnyObject {
    func didLoad()
    func addFolder(folderName: String)
    func deleteFolder(folderId: FolderEntityRealm.ID)
    func renameFolder(folderId: FolderEntityRealm.ID, folderName: String)
//    func toSetting()
}

class MainPresenter {
    
    enum Trigger {
        case on
        case off
    }
    struct Dependency {
        let makeFolderItems: MakeFolderItemsUseCase
        let getFolders: GetFoldersUseCase
        let addFolder: AddFolderUseCase
        let deleteFolder: DeleteFolderUseCase
        let renameFolder: RenameFolderUseCase
    }
    
    weak var view: MainView?
    let dependency: Dependency!
    
    init(view: MainView, dependency: Dependency) {
        self.view = view
        self.dependency = dependency
    }
}

extension MainPresenter: MainPresentation {
    func didLoad() {
        var folderEntities: [FolderEntity]?
        var firstIndex: Int?
        
        var makeFolderItems_Trigger = Trigger.off {
            didSet {
                if makeFolderItems_Trigger == Trigger.on {
                    dependency.makeFolderItems.execute(folderEntities!) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let folderItems):
                            self.view?.setFolders(folderItems, firstIndex!)
                        }
                    }
                }
            }
        }
        
        var getFolderEntities_Trigger = Trigger.off {
            didSet {
                if getFolderEntities_Trigger == Trigger.on {
                    dependency.getFolders.execute() { result in
                        switch result {
                        case .success(let value):
                            folderEntities = value.entities
                            firstIndex = value.index
                            makeFolderItems_Trigger = Trigger.on
                        }
                    }
                }
            }
        }
        
        getFolderEntities_Trigger = Trigger.on
    }
    
    func addFolder(folderName: String) {
        var folderEntities: [FolderEntity]?
        var firstIndex: Int?
        
        var makeFolderItems_Trigger = Trigger.off {
            didSet {
                if makeFolderItems_Trigger == Trigger.on {
                    dependency.makeFolderItems.execute(folderEntities!) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let folderItems):
                            self.view?.reSetFoldes(folderItems, firstIndex!)
                        }
                    }
                }
            }
        }
        
        var addFolderEntity_Trigger = Trigger.off {
            didSet {
                if addFolderEntity_Trigger == Trigger.on {
                    dependency.addFolder.execute(folderName) { result in
                        switch result {
                        case .success(let value):
                            folderEntities = value.entities
                            firstIndex = value.index
                            makeFolderItems_Trigger = Trigger.on
                        }
                    }
                }
            }
        }
        
        addFolderEntity_Trigger = .on
    }
    
    func deleteFolder(folderId: FolderEntity.ID) {
        var folderEntities: [FolderEntity]?
        var firstIndex: Int?
        
        var makeFolderItems_Trigger = Trigger.off {
            didSet {
                if makeFolderItems_Trigger == Trigger.on {
                    dependency.makeFolderItems.execute(folderEntities!) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let folderItems):
                            self.view?.reSetFoldes(folderItems, firstIndex!)
                        }
                    }
                }
            }
        }
        
        var deleteFolderEntity_Trigger = Trigger.off {
            didSet {
                if deleteFolderEntity_Trigger == Trigger.on {
                    dependency.deleteFolder.execute(folderId) { result in
                        switch result {
                        case .success(let value):
                            folderEntities = value.entities
                            firstIndex = value.index
                            makeFolderItems_Trigger = Trigger.on
                        }
                    }
                }
            }
        }
        
        deleteFolderEntity_Trigger = .on
    }
    
    func renameFolder(folderId: FolderEntity.ID, folderName: String) {
        var folderEntities: [FolderEntity]?
        var firstIndex: Int?
        var makeFolderItems_Trigger = Trigger.off {
            didSet {
                if makeFolderItems_Trigger == Trigger.on {
                    dependency.makeFolderItems.execute(folderEntities!) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let folderItems):
                            self.view?.reSetFoldes(folderItems, firstIndex!)
                        }
                    }
                }
            }
        }
        
        var renameFolderEntity_Trigger = Trigger.off {
            didSet {
                if renameFolderEntity_Trigger == Trigger.on {
                    dependency.renameFolder.execute(folderId, folderName) { result in
                        switch result {
                        case .success(let value):
                            folderEntities = value.entities
                            firstIndex = value.index
                            makeFolderItems_Trigger = Trigger.on
                        }
                    }
                }
            }
        }
        
        renameFolderEntity_Trigger = .on
    }
    
}
