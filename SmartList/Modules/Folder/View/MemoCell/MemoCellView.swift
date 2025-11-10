

import UIKit

class MemoCellView: UIView, UIContentView  {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var memoTitleLabel: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    
    var memoId: MemoEntity.ID
    
    var deleteBlock: ((MemoEntity.ID) -> Void)?
    
    var memoConfiguration: MemoCellConfiguration! {
        didSet {
            memoTitleLabel.text = memoConfiguration.title
            memoId = memoConfiguration.memoId
        }
    }
    
    var configuration: UIContentConfiguration  {
        get {
            return memoConfiguration
        }
        set {
            guard let newConfi = newValue as? MemoCellConfiguration else { return }
            memoConfiguration = newConfi
        }
    }
    
    init(configuration: MemoCellConfiguration) {
        super.init(frame: .zero)
        loadView()
        firstConfiguration()
        self.configuration = configuration
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadView() {
        Bundle.main.loadNibNamed("\(MemoCellView.self)", owner: self)
       addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0)
        ])
    }
    
    func createMenu() -> UIMenu {
        var menuChildren = [UIMenuElement]()
        
        var deleteAction = UIAction(title: "削除",image: UIImage(systemName: "trash"), attributes: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            deleteBlock?(memoId)
        })
        menuChildren.append(deleteAction)
        
        return UIMenu(title: "", options: .singleSelection, children: menuChildren)
    }
    
    func firstConfiguration() {
        
        menuButton.menu = createMenu()
   
        memoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        memoTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        memoTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        memoTitleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12).isActive = true
        memoTitleLabel.heightAnchor.constraint(equalToConstant: 30 * UIScreen.main.bounds.size.width / 390).isActive = true
        
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        menuButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        menuButton.leftAnchor.constraint(equalTo: memoTitleLabel.rightAnchor, constant: 1).isActive = true
        menuButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12).isActive = true
        menuButton.widthAnchor.constraint(equalToConstant: 30 * UIScreen.main.bounds.size.width / 390).isActive = true
    }
}

extension Notification.Name {
//    static let notifyTransfer = Notification.Name("notifyTransfer")
    static let notifyDeleteMemo = Notification.Name("notifyDeleteMemo")
}
