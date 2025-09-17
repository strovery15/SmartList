
import UIKit

protocol FolderWireframe {
    func presentMemoView(folderId: FolderEntity.ID, memoId: MemoTitleEntity.ID?)
}

class FolderRouter: FolderWireframe {
    
    weak var folderViewController: UIViewController?
    
    init(view: UIViewController) {
        self.folderViewController = view
    }
    
    func presentMemoView(folderId: FolderEntity.ID, memoId: MemoTitleEntity.ID?) {
        let appDependencies = AppDependencies()
        let viewController = appDependencies.assembleMemoModule(folderId, memoId)
        folderViewController?.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
