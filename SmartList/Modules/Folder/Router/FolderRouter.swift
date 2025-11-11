
import UIKit

protocol FolderWireframe {
    func presentMemoView(folderId: FolderEntity.ID, memoId: MemoEntity.ID?)
}

class FolderRouter: FolderWireframe {
    
    weak var folderViewController: UIViewController?
    
    init(view: UIViewController) {
        self.folderViewController = view
    }
    
    func presentMemoView(folderId: FolderEntity.ID, memoId: MemoEntity.ID?) {
        let appDependencies = AppDependencies()
        let viewController = appDependencies.assembleMemoModule(folderId, memoId)
        folderViewController?.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
