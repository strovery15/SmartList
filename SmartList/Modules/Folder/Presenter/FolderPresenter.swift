

import Foundation

protocol FolderPresentation: AnyObject {
    func didLoad(view: FolderView,_ id: FolderEntity.ID)
    func didAppear(view: FolderView)
    func selectMemo(folderId: FolderEntity.ID, memoId: MemoTitleEntity.ID)
    func deleteFolder(folderId: FolderEntity.ID)
    func deleteMemo(folderId: FolderEntity.ID, memoId: MemoTitleEntity.ID)
    func reorderMemo(folderId: FolderEntity.ID, from: Int, to: Int)
}

class FolderPresenter {
    struct Dependency {
        let router: FolderWireframe
        
        let getMemoTitles: GetMemoTitlesUseCase
        let deleteMemoTitle: DeleteMemoTitleUseCase
        let reorderMemoTitle: ReorderMemoTitleUseCase
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
        dependency.getMemoTitles.execute(id) { [weak self] result in
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
    
    func selectMemo(folderId: FolderEntity.ID, memoId: MemoTitleEntity.ID) {
        dependency.router.presentMemoView(viewCon: currentView!, folderId: folderId, memoId: memoId)
    }
    
    func deleteFolder(folderId: FolderEntity.ID) {
        NotificationCenter.default.post(name: .notifyDeleteFolder, object: nil, userInfo: ["id": folderId])
    }
    
    func deleteMemo(folderId: FolderEntity.ID, memoId: MemoTitleEntity.ID) {
        dependency.deleteMemoTitle.execute(folderId, memoId)
    }
    
    func reorderMemo(folderId: FolderEntity.ID, from: Int, to: Int) {
        dependency.reorderMemoTitle.execute(folderId, from, to)
    }

}

extension Notification.Name {
    static let notifySelectMemo = Notification.Name("notifySelectMemo")
    static let notifyDeleteFolder = Notification.Name("notifyDeleteFolder")
}

