

import UIKit

protocol MemoView: AnyObject {
    
}

class MemoViewController: UIViewController {
    
    var presenter: MemoPresentation!
    var folderId: FolderEntity.ID!
    var memoId: MemoBodyEntity.ID?

    override func viewDidLoad() {
        super.viewDidLoad()

        print(folderId.uuidString)
        print(memoId?.uuidString)
        view.backgroundColor = .blue
    }
    
    init?(coder: NSCoder, folderId: FolderEntity.ID, memoId: MemoTitleEntity.ID?) {
        super.init(coder: coder)
        self.folderId = folderId
        self.memoId = memoId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
}

extension MemoViewController: MemoView {
    
}
