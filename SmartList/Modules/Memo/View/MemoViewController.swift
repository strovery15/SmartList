

import UIKit

protocol MemoView: AnyObject {
    func setText(memoId: MemoEntity.ID, text: String)
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
    
    func dismissView() {
        self.navigationController?.popViewController(animated: true)
    }
}

private extension MemoViewController {
    
    func firstConfiguration() {
        
        view.backgroundColor = .blue
        
        createVisualEffect()
        let editButtonImage = UIImage(systemName: "ellipsis")
        let editButton = UIBarButtonItem(image: editButtonImage, style: .plain, target: self, action: nil)
        editButton.menu = createMenu()
        saveButton = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(saveButtonAction(_:)))
        let closeButton = UIBarButtonItem(title: "閉じる", style: .plain, target: self, action: #selector(closeButton(_:)))
        self.navigationItem.rightBarButtonItems = [editButton, saveButton, closeButton]
    }
    
    func createVisualEffect() {
        let blur = UIBlurEffect(style: .systemMaterialLight)
        visualEffectView = UIVisualEffectView(effect: blur)
        visualEffectView.frame = CGRect(x: 0, y: 0, width: 230, height: 230)
        let viewWidth = UIScreen.main.bounds.width
        let viewHeight = UIScreen.main.bounds.height
        visualEffectView.center = CGPoint(x: viewWidth/2, y: viewHeight/2)
        visualEffectView.layer.cornerRadius = 10
        visualEffectView.clipsToBounds = true
        
        let subView = UIView(frame: view.frame)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 230, height: 50))
        label.textAlignment = .center
        
        label.center = CGPoint(x: 115, y: 200)
        label.text = "メモを保存しました"
        label.textColor = .darkGray
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        imageView.center = CGPoint(x: 115, y: 100)
        imageView.image = UIImage(systemName: "checkmark.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 80, weight: .regular, scale: .large))
        imageView.tintColor = .lightGray
        subView.addSubview(label)
        subView.addSubview(imageView)
        visualEffectView.contentView.addSubview(subView)
        
        view.addSubview(visualEffectView)
        visualEffectView.isHidden = true
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
        let text = textView.text
        presenter.saveMemo(folderId: folderId, memoId: memoId!, text: text!)
        saveButton.isEnabled = false
        visualEffectView.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0.6) { [self] in
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
}

extension MemoViewController: UITextViewDelegate {
    
    //textView
    func configureTextView() {
        textView.delegate = self
        textView.text = ""
        textView.font = UIFont.systemFont(ofSize: 20)
    }
}
