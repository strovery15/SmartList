

import UIKit

protocol MainWireframe {
    func presentMemoView(folderId: FolderEntity.ID, memoId: MemoTitleEntity.ID)
}

class MainRouter: MainWireframe {
    
//    unowned var mainViewController: UIViewController
    
    func presentMemoView(folderId: FolderEntity.ID, memoId: MemoTitleEntity.ID) {
        let viewController = AppDependencies.shared.assembleMemoModule(memoId)
    }
    
}
