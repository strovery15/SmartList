

import UIKit

protocol MemoView: AnyObject {
    func setText(memoId: MemoEntity.ID, text: String)
}

class MemoViewController: UIViewController {
    
    var presenter: MemoPresentation!
    var folderId: FolderEntity.ID!
    var memoId: MemoEntity.ID?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blue
        presenter.didLoad(folderId: folderId, memoId: memoId)
    }
    
}

extension MemoViewController: MemoView {
    
    func setText(memoId: MemoEntity.ID, text: String) {
        print(memoId)
        print(text)
    }
}
