

import Foundation

protocol MemoPresentation: AnyObject {
    func didLoad(folderId: FolderEntity.ID, memoId: MemoEntity.ID?)
    func saveMemo(folderId: FolderEntity.ID, memoId: MemoEntity.ID, text: String)
}

class MemoPresenter {
    
    struct Dependency {
        let getMemoEntity: GetMemoEntityUseCase
        let saveMemoEntity: SaveMemoEntityUseCase
    }
    
    weak var view: MemoView?
    let dependency: Dependency!
    
    init(view: MemoView, dependency: Dependency) {
        self.view = view
        self.dependency = dependency
    }
}

extension MemoPresenter: MemoPresentation {
    
    func didLoad(folderId: FolderEntity.ID, memoId: MemoEntity.ID?) {
        dependency.getMemoEntity.execute(folderId, memoId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let value):
                self.view?.setText(memoId: value.memoId, text: value.text)
            }
        }
    }
    
    func saveMemo(folderId: FolderEntity.ID, memoId: MemoEntity.ID, text: String) {
        dependency.saveMemoEntity.execute(folderId, memoId, text)
    }
    
}
