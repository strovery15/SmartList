

import Foundation

protocol MainPresentation: AnyObject {
    func didLoad()
//    func addFolder(folderName: String)
//    func toSetting()
}

class MainPresenter {
    struct Dependency {
        let makeFolderChiefVC: MakeFolderChiefVCUseCase!
        let getFolderEntities: GetFolderEntitiesUseCase!
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
        var folderEntities: [FolderEntity] = [] {
            didSet {
                dependency.makeFolderChiefVC.execute(folderEntities) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let vc):
                        self.view?.showFolderChief(vc)
                    }
                }
            }
        }
        
        dependency.getFolderEntities.execute() {  result in
            switch result {
            case .success(let entities):
                folderEntities = entities
            }
        }
        
    }
    
}
