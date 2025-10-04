

import UIKit

protocol MemoView: AnyObject {
    func setText(memoId: MemoEntityRealm.ID, text: String)
    func dismissView()
}

class MemoViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView! {
        didSet {
            configureTextView()
        }
    }
    
    var saveButton: UIBarButtonItem!
    var visualEffectView: UIVisualEffectView!
    
    var presenter: MemoPresentation!
    var folderId: FolderEntityRealm.ID!
    var memoId: MemoEntityRealm.ID?

    private var keyboardHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstConfiguration()
        presenter.didLoad(folderId: folderId, memoId: memoId)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("willdisappear")
        saveMemo()
        NotificationCenter.default.post(name: .notifyDismissMemoView, object: nil)
    }
    
}

extension MemoViewController: MemoView {
    
    func setText(memoId: MemoEntityRealm.ID, text: String) {
        self.memoId = memoId
        textView.text = text
    }
    
    func dismissView() {
        self.navigationController?.popViewController(animated: true)
    }
}

private extension MemoViewController {
    
    func firstConfiguration() {
        
        view.backgroundColor = .blue
        
        configureLayout()
        
        configureBarButtons()
        
        createVisualEffect()
        
        NotificationCenter.default.addObserver(self, selector: #selector(notifyKeyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(notifyWillResignActive(_:)), name: .notifyWillResignActive, object: nil)
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
    
    func adjustTextView() {
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
    
    @objc func notifyWillResignActive(_ notification: Notification) {
        saveMemo()
    }
    
    func saveMemo() {
        let text = textView.text
        presenter.saveMemo(folderId: folderId, memoId: memoId!, text: text!)
    }
    
    func configureBarButtons() {
        let editButtonImage = UIImage(systemName: "ellipsis")
        let editButton = UIBarButtonItem(image: editButtonImage, style: .plain, target: self, action: nil)
        editButton.menu = createMenu()
        saveButton = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(saveButtonAction(_:)))
        let closeButton = UIBarButtonItem(title: "閉じる", style: .plain, target: self, action: #selector(closeButton(_:)))
        self.navigationItem.rightBarButtonItems = [editButton, saveButton, closeButton]
    }
    
    func createMenu() -> UIMenu {
        var menus = [UIMenuElement]()
        menus.append(UIAction(title: "削除",image: UIImage(systemName: "trash"), attributes: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            let alertController = UIAlertController(title: "メモの削除", message: "このメモを削除しますか？", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "削除", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                presenter.deleteMemo(folderId: folderId, memoId: memoId!)
            }
            alertController.addAction(deleteAction)
            
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true)
            
        }))
        
        return UIMenu(title: "", options: .singleSelection, children: menus)
    }

    @objc func saveButtonAction(_ sender: UIBarButtonItem) {
        saveMemo()
        saveButton.isEnabled = false
        visualEffectView.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0.6) { [weak self] in
            guard let self = self else { return }
            visualEffectView.alpha = 0
            visualEffectView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        } completion: { [weak self] _ in
            guard let self = self else { return }
            saveButton.isEnabled = true
            visualEffectView.isHidden = true
            visualEffectView.transform = .identity
            visualEffectView.alpha = 1.0
        }
    }
    
    @objc func closeButton(_ sender: UIBarButtonItem) {
        textView.resignFirstResponder()
    }
    
    func createVisualEffect() {
        let blur = UIBlurEffect(style: .systemMaterialLight)
        visualEffectView = UIVisualEffectView(effect: blur)
        visualEffectView.frame = CGRect(x: 0, y: 0, width: 230 * UIScreen.main.bounds.size.width / 390, height: 230 * UIScreen.main.bounds.size.width / 390)
        let viewWidth = UIScreen.main.bounds.width
        let viewHeight = UIScreen.main.bounds.height
        visualEffectView.center = CGPoint(x: viewWidth/2, y: viewHeight/2)
        visualEffectView.layer.cornerRadius = 10 * UIScreen.main.bounds.size.width / 390
        visualEffectView.clipsToBounds = true
        
        let subView = UIView(frame: view.frame)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 230 * UIScreen.main.bounds.size.width / 390, height: 50 * UIScreen.main.bounds.size.width / 390))
        label.textAlignment = .center
        
        label.center = CGPoint(x: 115 * UIScreen.main.bounds.size.width / 390, y: 200 * UIScreen.main.bounds.size.width / 390)
        label.text = "メモを保存しました"
        label.textColor = .darkGray
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150 * UIScreen.main.bounds.size.width / 390, height: 150 * UIScreen.main.bounds.size.width / 390))
        imageView.center = CGPoint(x: 115 * UIScreen.main.bounds.size.width / 390, y: 100 * UIScreen.main.bounds.size.width / 390)
        imageView.image = UIImage(systemName: "checkmark.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 80 * UIScreen.main.bounds.size.width / 390, weight: .regular, scale: .large))
        imageView.tintColor = .lightGray
        subView.addSubview(label)
        subView.addSubview(imageView)
        visualEffectView.contentView.addSubview(subView)
        
        view.addSubview(visualEffectView)
        visualEffectView.isHidden = true
    }

}

extension MemoViewController: UITextViewDelegate {
    
    //textView
    func configureTextView() {
        textView.text = ""
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.delegate = self
    }
    
    func textViewDidChange(_ textView: UITextView) {
        adjustTextView()
    }
}

extension Notification.Name {
    static let notifyDismissMemoView = Notification.Name("notifyDismissMemoView")
}
