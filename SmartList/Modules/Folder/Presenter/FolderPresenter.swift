

import Foundation

protocol FolderPresentation: AnyObject {
    func didAppear(_ view: FolderView)
}

class FolderPresenter {
    struct Dependency {
        
    }
    
    weak var currentView: FolderView?
    let dependency: Dependency!
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
}

extension FolderPresenter: FolderPresentation {
    func didAppear(_ view: FolderView) {
        self.currentView = view
    }
    
}
