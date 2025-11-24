

import UIKit

protocol MemoView: AnyObject {
    
    func setText(memoId: MemoEntity.ID, text: String)
    func dismissView()
}

class MemoViewController: UIViewController {
    
    var presenter: MemoPresentation!
    var folderId: FolderEntity.ID!
    var memoId: MemoEntity.ID?
    
    private var keyboardHeight: CGFloat!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var saveEffectView: SaveEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstConfiguration()
        presenter.didLoad(folderId: folderId, memoId: memoId)
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        textView.resignFirstResponder()
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        saveMemo()
        saveMemoAnimation()
    }
    
}

extension MemoViewController: MemoView {
    
    func setText(memoId: MemoEntity.ID, text: String) {
        self.memoId = memoId
        textView.text = text
    }
    
    func dismissView() {
        self.navigationController?.popViewController(animated: true)
    }
}

private extension MemoViewController {
    
    func firstConfiguration() {
        
        textView.delegate = self
        editButton.menu = createMenu()
        
        saveEffectView.frame = CGRect(x: 0, y: 0, width: 230 * UIScreen.main.bounds.size.width / 390, height: 230 * UIScreen.main.bounds.size.width / 390)
        let viewWidth = UIScreen.main.bounds.width
        let viewHeight = UIScreen.main.bounds.height
        saveEffectView.center = CGPoint(x: viewWidth/2, y: viewHeight/2)
        saveEffectView.isHidden = true
        
        configureLayout()
        
        NotificationCenter.default.addObserver(self, selector: #selector(notifyKeyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func configureLayout() {
        
        //textView
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
    
    @objc func notifyKeyboardWillShow(_ notification: Notification) {
        let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        keyboardHeight = keyboardFrame!.height + 100
        adjustTextView()
    }
    
    func saveMemo() {
        let text = textView.text
        presenter.saveMemo(memoId: memoId!, text: text!)
    }
    
    func saveMemoAnimation() {
        saveButton.isEnabled = false
        saveEffectView.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0.6) { [weak self] in
            guard let self = self else { return }
            saveEffectView.alpha = 0
            saveEffectView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        } completion: { [weak self] _ in
            guard let self = self else { return }
            saveButton.isEnabled = true
            saveEffectView.isHidden = true
            saveEffectView.transform = .identity
            saveEffectView.alpha = 1.0
        }
    }
    
    func createMenu() -> UIMenu {
        var menuChildren = [UIMenuElement]()
        
        menuChildren.append(UIAction(title: "削除",image: UIImage(systemName: "trash"), attributes: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            
            let alertController = UIAlertController(title: "メモの削除", message: "このメモを削除しますか？", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "削除", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                presenter.deleteMemo(memoId: memoId!)
            }
            alertController.addAction(deleteAction)
            
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true)
        }))
        
        return UIMenu(title: "", options: .singleSelection, children: menuChildren)
    }

}

extension MemoViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        adjustTextView()
        saveMemo()
    }
}

extension MemoViewController {
    
    func adjustTextView() {
        //TextViewのオフセット調整
        let cursorPosition = textView.selectedTextRange?.start
        let cursorY = textView.caretRect(for: cursorPosition!).origin.y
        let currentCursorY = cursorY - textView.contentOffset.y
        
        if currentCursorY > (textView.frame.height - keyboardHeight) {
            let increment = currentCursorY - (textView.frame.height - keyboardHeight)
            if textView.contentSize.height < textView.frame.height {
                textView.contentSize.height = textView.frame.height + increment
            } else {
                textView.contentSize.height += increment
            }
            let offset = CGPoint(x: 0.0, y: textView.contentOffset.y + increment)
            textView.setContentOffset(offset, animated: false)
        }
    }
}
