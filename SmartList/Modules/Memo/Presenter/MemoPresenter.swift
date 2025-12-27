

import Foundation

protocol MemoPresentation: AnyObject {
    
    func didLoad(folderId: FolderEntity.ID, memoId: MemoEntity.ID?)
    func deleteMemo(memoId: MemoEntity.ID)
    func saveMemo(memoId: MemoEntity.ID, text: String)
}

class MemoPresenter {
    
    struct Dependency {
        let getMemoEntity: GetMemoEntityUseCase
        let deleteMemoEntity: DeleteMemoEntityUseCase
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
    
    func saveMemo(memoId: MemoEntity.ID, text: String) {
        dependency.saveMemoEntity.execute(memoId, text)
    }
    
    func deleteMemo(memoId: MemoEntity.ID) {
        dependency.deleteMemoEntity.execute(memoId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success():
                self.view?.dismissView()
            }
        }
    }
    
    
    
}
