

import UIKit

class MemoCellView: UIView, UIContentView  {
    
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var memoTitleLabel: UILabel! {
        didSet {
            configureMemoTitleLabel()
        }
    }
    @IBOutlet weak var menuButton: UIButton! {
        didSet {
            configureMemoButton()
        }
    }
    
    
    var memoConfiguration: MemoCellConfiguration! {
        didSet {
            if memoTitleLabel != nil && menuButton != nil {
                configureMemoTitleLabel()
                configureMemoButton()
            }
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
        self.configuration = configuration
        loadView()
        firstConfiguration()
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
    
    func firstConfiguration() {
   
        configureLayout()
    }
    
    func configureLayout() {
        
        //memoTitleLabel
        memoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        memoTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        memoTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        memoTitleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12).isActive = true
        memoTitleLabel.heightAnchor.constraint(equalToConstant: 30 * UIScreen.main.bounds.size.width / 390).isActive = true
        
        //menuButton
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        menuButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        menuButton.leftAnchor.constraint(equalTo: memoTitleLabel.rightAnchor, constant: 1).isActive = true
        menuButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12).isActive = true
        menuButton.widthAnchor.constraint(equalToConstant: 30 * UIScreen.main.bounds.size.width / 390).isActive = true
        
    }
    
    func configureMemoTitleLabel() {
        memoTitleLabel.text = memoConfiguration.title
    }
    
    func configureMemoButton() {
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 25.0 * UIScreen.main.bounds.size.width / 390, weight: .regular, scale: .small)
        let systemImage = UIImage(systemName: "ellipsis", withConfiguration: symbolConfiguration)
        menuButton.setTitle("", for: .normal)
        menuButton.setImage(systemImage, for: .normal)
        menuButton.menu = createMenu()
        menuButton.showsMenuAsPrimaryAction = true
        menuButton.tintColor = UIColor.systemGray4
    }
    
    func createMenu() -> UIMenu {
        var menus = [UIMenuElement]()
//        menus.append(UIAction(title: "移動", image: UIImage(systemName: "arrow.right"), handler: {_ in
//            NotificationCenter.default.post(name: .notifyTransfer, object: nil)
//        }))
        menus.append(UIAction(title: "削除",image: UIImage(systemName: "trash"), attributes: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            NotificationCenter.default.post(name: .notifyDeleteMemo, object: nil, userInfo: ["folderId": self.memoConfiguration.folderId!, "memoId": self.memoConfiguration.memoId!])
            
        }))
        
        return UIMenu(title: "", options: .singleSelection, children: menus)
    }
    
    
}

extension Notification.Name {
//    static let notifyTransfer = Notification.Name("notifyTransfer")
    static let notifyDeleteMemo = Notification.Name("notifyDeleteMemo")
}
