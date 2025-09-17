

import Foundation

protocol FolderPresentation: AnyObject {
    func didAppear(id: FolderEntity.ID)
    func addMemo(folderId: FolderEntity.ID)
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
    
    weak var view: FolderView?
    let dependency: Dependency!
    
    init(view: FolderView, dependency: Dependency) {
        self.view = view
        self.dependency = dependency
    }
}

extension FolderPresenter: FolderPresentation {
    
    func didAppear(id: FolderEntity.ID) {
        dependency.getMemoTitles.execute(id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let entities):
                self.view?.setRepository(entities)
            }
        }
    }
    
    func addMemo(folderId: FolderEntity.ID) {
        dependency.router.presentMemoView(folderId: folderId, memoId: nil)
    }
    
    func selectMemo(folderId: FolderEntity.ID, memoId: MemoTitleEntity.ID) {
        dependency.router.presentMemoView(folderId: folderId, memoId: memoId)
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

