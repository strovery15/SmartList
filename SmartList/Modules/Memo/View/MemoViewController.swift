

import UIKit

protocol MemoView: AnyObject {
    func setText(memoId: MemoEntity.ID, text: String)
}

class MemoViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView! {
        didSet {
            configureTextView()
        }
    }
    
    var presenter: MemoPresentation!
    var folderId: FolderEntity.ID!
    var memoId: MemoEntity.ID?

    override func viewDidLoad() {
        super.viewDidLoad()

        firstConfiguration()
        presenter.didLoad(folderId: folderId, memoId: memoId)
    }
    
}

extension MemoViewController: MemoView {
    
    func setText(memoId: MemoEntity.ID, text: String) {
        self.memoId = memoId
        textView.text = text
    }
}

private extension MemoViewController {
    
    func firstConfiguration() {
        view.backgroundColor = .blue
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(closeButtonAction(_:)))
        self.navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc func closeButtonAction(_ sender: UIBarButtonItem) {
        let currentText = textView.text
        print(currentText)
        textView.resignFirstResponder()
    }
}

extension MemoViewController: UITextViewDelegate {
    
    //textView
    func configureTextView() {
        textView.delegate = self
        textView.text = ""
        textView.font = UIFont.systemFont(ofSize: 20)
    }
}
