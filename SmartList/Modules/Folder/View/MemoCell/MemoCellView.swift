

import UIKit

class MemoCellView: UIView, UIContentView  {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var memoTitleLabel: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    
    
    var memoConfiguration: MemoCellConfiguration!
    var configuration: UIContentConfiguration  {
        get {
            memoConfiguration
        }
        set {
            guard let newConfi = newValue as? MemoCellConfiguration else { return }
            memoConfiguration = newConfi
        }
    }
    
    init(configuration: MemoCellConfiguration) {
        super.init(frame: .zero)
        self.configuration = configuration
        loadView()
        configureLayout()
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
    
    func configureLayout() {
        memoTitleLabel.text = memoConfiguration.title
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .regular, scale: .small)
        let systemImage = UIImage(systemName: "ellipsis", withConfiguration: symbolConfiguration)
        menuButton.setTitle("", for: .normal)
        menuButton.setImage(systemImage, for: .normal)
        menuButton.menu = createMenu()
        menuButton.showsMenuAsPrimaryAction = true
        menuButton.tintColor = UIColor.systemGray4
        
        NotificationCenter.default.addObserver(self, selector: #selector(resetTitle(_:)), name: .notifyResetTitle, object: nil)
    }
    
    func createMenu() -> UIMenu {
        var menus = [UIMenuElement]()
//        menus.append(UIAction(title: "移動", image: UIImage(systemName: "arrow.right"), handler: {_ in
//            NotificationCenter.default.post(name: .notifyTransfer, object: nil)
//        }))
        menus.append(UIAction(title: "削除",image: UIImage(systemName: "trash"), attributes: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            NotificationCenter.default.post(name: .notifyDeleteMemo, object: nil, userInfo: ["id": self.memoConfiguration.id!])
            
        }))
        
        return UIMenu(title: "", options: .singleSelection, children: menus)
    }
    
    @objc func resetTitle(_ notification: Notification) {
        let memoId = notification.userInfo!["memoId"] as! MemoTitleEntity.ID
        let text = notification.userInfo!["text"] as! String
        if memoId == memoConfiguration.id {
            memoTitleLabel.text = text
        }
    }
    
}

extension Notification.Name {
//    static let notifyTransfer = Notification.Name("notifyTransfer")
    static let notifyDeleteMemo = Notification.Name("notifyDeleteMemo")
}
