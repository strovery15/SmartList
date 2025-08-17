

import Foundation
import TabPageViewController

enum Trigger {
    case on
    case off
}


protocol MainPresentation: AnyObject {
    func didLoad()
    func addFolder(folderName: String)
//    func toSetting()
}

class MainPresenter {
    struct Dependency {
        let makeFolderChiefViewCon: UseCase<[FolderEntity], TabPageViewController, Never>
        let getFolderEntities: UseCase<Void, [FolderEntity], Never>
        let addFolderEntity: UseCase<String, Void, Never>
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
                    dependency.getFolderEntities.execute(()) { result in
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
                    dependency.getFolderEntities.execute(()) { result in
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
                    dependency.addFolderEntity.execute(folderName) { result in
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
}
