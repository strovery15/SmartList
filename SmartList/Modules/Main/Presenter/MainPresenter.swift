

import Foundation
import TabPageViewController

protocol MainPresentation: AnyObject {
    func didLoad()
    func addFolder(folderName: String)
    func deleteFolder(folderId: FolderEntity.ID)
//    func toSetting()
}

class MainPresenter {
    
    enum Trigger {
        case on
        case off
    }
    struct Dependency {
        
        let makeFolderChiefViewCon: MakeFolderChiefViewConUseCase
        let getFolders: GetFoldersUseCase
        let addFolder: AddFolderUseCase
        let deleteFolder: DeleteFolderUseCase
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
        var folderEntities: [FolderEntity] = []
        var makeFolderChiefViewCon_Trigger = Trigger.off {
            didSet {
                if makeFolderChiefViewCon_Trigger == Trigger.on {
                    dependency.makeFolderChiefViewCon.execute(folderEntities) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let vc):
                            self.view?.showFolderChief(vc)
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
                        case .success(let entities):
                            folderEntities = entities
                            makeFolderChiefViewCon_Trigger = Trigger.on
                        }
                    }
                }
            }
        }
        
        getFolderEntities_Trigger = Trigger.on
    }
    
    func addFolder(folderName: String) {
        var folderEntities: [FolderEntity] = []
        var makeFolderChiefVC_Trigger = Trigger.off {
            didSet {
                if makeFolderChiefVC_Trigger == Trigger.on {
                    dependency.makeFolderChiefViewCon.execute(folderEntities) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let vc):
                            self.view?.reShowFolderChief(vc)
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
                        case .success(let entities):
                            folderEntities = entities
                            makeFolderChiefVC_Trigger = Trigger.on
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
                        case .success(()):
                            getFolderEntities_Trigger = Trigger.on
                        }
                    }
                }
            }
        }
        
        addFolderEntity_Trigger = .on
    }
    
    func deleteFolder(folderId: FolderEntity.ID) {
        var folderEntities: [FolderEntity] = []
        var makeFolderChiefVC_Trigger = Trigger.off {
            didSet {
                if makeFolderChiefVC_Trigger == Trigger.on {
                    dependency.makeFolderChiefViewCon.execute(folderEntities) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let vc):
                            self.view?.reShowFolderChief(vc)
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
                        case .success(let entities):
                            folderEntities = entities
                            makeFolderChiefVC_Trigger = Trigger.on
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
                        case .success(()):
                            getFolderEntities_Trigger = Trigger.on
                        }
                    }
                }
            }
        }
        
        deleteFolderEntity_Trigger = .on
    }
    
}
