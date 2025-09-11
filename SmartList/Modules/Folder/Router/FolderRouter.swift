
import UIKit

protocol FolderWireframe {
    func presentMemoView(viewCon: FolderView, folderId: FolderEntity.ID, memoId: MemoTitleEntity.ID)
}

class FolderRouter: FolderWireframe {
    
    func presentMemoView(viewCon: FolderView, folderId: FolderEntity.ID, memoId: MemoTitleEntity.ID) {
        
        unowned let folderViewController = viewCon as! UIViewController
        let viewController = AppDependencies.shared.assembleMemoModule(folderId, memoId)
        folderViewController.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
