

import Foundation

protocol FolderPresentation: AnyObject {
    func didLoad(view: FolderView,_ id: FolderEntity.ID)
    func didAppear(view: FolderView)
    func deleteFolder(id: FolderEntity.ID)
    func didDeleteMemo(folderId: FolderEntity.ID, memoId: MemoTitleEntity.ID)
    func didReorderMemo(folderId: FolderEntity.ID, from: Int, to: Int)
}

class FolderPresenter {
    struct Dependency {
        let getMemoTitleEntities: GetMemoTitleEntitiesUseCase
        let deleteMemoTitleEntity: DeleteMemoTitleEntityUseCase
        let reorderMemoTitleEntity: ReorderMemoTitleEntityUseCase
    }
    
    weak var currentView: FolderView?
    let dependency: Dependency!
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
}

extension FolderPresenter: FolderPresentation {
    func didLoad(view: FolderView,_ id: FolderEntity.ID) {
        self.currentView = view
        dependency.getMemoTitleEntities.execute(id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let entities):
                self.currentView?.setRepository(entities)
            }
        }
    }
    
    func didAppear(view: FolderView) {
        self.currentView = view
    }
    
    func deleteFolder(id: FolderEntity.ID) {
        
    }
    
    func didDeleteMemo(folderId: FolderEntity.ID, memoId: MemoTitleEntity.ID) {
        dependency.deleteMemoTitleEntity.execute(folderId, memoId)
    }
    
    func didReorderMemo(folderId: FolderEntity.ID, from: Int, to: Int) {
        dependency.reorderMemoTitleEntity.execute(folderId, from, to)
    }
    
}
