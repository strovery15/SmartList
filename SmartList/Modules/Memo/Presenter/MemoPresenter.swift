

import Foundation

protocol MemoPresentation: AnyObject {
    func didLoad(folderId: FolderEntity.ID, memoId: MemoEntity.ID?)
}

class MemoPresenter {
    
    struct Dependency {
        let getMemoEntity: GetMemoEntityUseCase
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
    
}
