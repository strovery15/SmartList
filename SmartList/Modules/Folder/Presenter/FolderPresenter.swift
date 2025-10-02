

import Foundation

protocol FolderPresentation: AnyObject {
    func didLoad(id: FolderEntityRealm.ID)
    func reloadMemo(id: FolderEntityRealm.ID)
    func addMemo(folderId: FolderEntityRealm.ID)
    func selectMemo(folderId: FolderEntityRealm.ID, memoId: MemoTitleEntityRealm.ID)
    func deleteFolder(folderId: FolderEntityRealm.ID)
    func deleteMemo(folderId: FolderEntityRealm.ID, memoId: MemoTitleEntityRealm.ID)
    func reorderMemo(folderId: FolderEntityRealm.ID, from: Int, to: Int)
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
    
    func didLoad(id: FolderEntityRealm.ID) {
        dependency.getMemoTitles.execute(id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let memoTitles):
                self.view?.setRepository(memoTitles)
            }
        }
    }
    
    func reloadMemo(id: FolderEntityRealm.ID) {
        dependency.getMemoTitles.execute(id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let memoTitles):
                self.view?.reSetRepository(memoTitles)
            }
        }
    }
    
    func addMemo(folderId: FolderEntityRealm.ID) {
        dependency.router.presentMemoView(folderId: folderId, memoId: nil)
    }
    
    func selectMemo(folderId: FolderEntityRealm.ID, memoId: MemoTitleEntityRealm.ID) {
        dependency.router.presentMemoView(folderId: folderId, memoId: memoId)
    }
    
    func deleteFolder(folderId: FolderEntityRealm.ID) {
        NotificationCenter.default.post(name: .notifyDeleteFolder, object: nil, userInfo: ["id": folderId])
    }
    
    func deleteMemo(folderId: FolderEntityRealm.ID, memoId: MemoTitleEntityRealm.ID) {
        dependency.deleteMemoTitle.execute(folderId, memoId)
    }
    
    func reorderMemo(folderId: FolderEntityRealm.ID, from: Int, to: Int) {
        dependency.reorderMemoTitle.execute(folderId, from, to)
    }

}

extension Notification.Name {
    static let notifySelectMemo = Notification.Name("notifySelectMemo")
    static let notifyDeleteFolder = Notification.Name("notifyDeleteFolder")
}

