

import Foundation

protocol FolderPresentation: AnyObject {
    
    func willAppear(id: FolderEntity.ID)
    func addMemo(folderId: FolderEntity.ID)
    func selectMemo(folderId: FolderEntity.ID, memoId: MemoEntity.ID)
    func deleteMemo(memoId: MemoEntity.ID)
    func reorderMemo(from: MemoEntity.ID, to: MemoEntity.ID)
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
    
    func willAppear(id: FolderEntity.ID) {
        dependency.getMemoTitles.execute(id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let memoTitles):
                self.view?.setRepository(memoTitles)
            }
        }
    }
    
    func addMemo(folderId: FolderEntity.ID) {
        dependency.router.presentMemoView(folderId: folderId, memoId: nil)
    }
    
    func selectMemo(folderId: FolderEntity.ID, memoId: MemoEntity.ID) {
        dependency.router.presentMemoView(folderId: folderId, memoId: memoId)
    }
    
    func deleteMemo(memoId: MemoEntity.ID) {
        dependency.deleteMemoTitle.execute(memoId)
    }
    
    func reorderMemo(from: MemoEntity.ID, to: MemoEntity.ID) {
        dependency.reorderMemoTitle.execute(from, to)
    }

}

