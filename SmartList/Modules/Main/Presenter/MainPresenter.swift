

import Foundation

protocol MainPresentation: AnyObject {
    func didLoad()
//    func addFolder(folderName: String)
//    func toSetting()
}

class MainPresenter {
    struct Dependency {
        let makeFolderChiefVC: MakeFolderChiefVCUseCase!
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
        dependency.makeFolderChiefVC.execute() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let vc):
                self.view?.showFolderChief(vc)
            }
        }
    }
    
}
