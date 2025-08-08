

import Foundation

protocol MainPresentation {
    func didLoad()
//    func addFolder(folderName: String)
//    func toSetting()
}

class MainPresenter {
    struct Dependency {
        
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
        
    }
    
}
