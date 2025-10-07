

import UIKit
import RealmSwift

class HeaderCellView: UIView, UIContentView {
    
    
    @IBOutlet var view: UIView! {
        didSet {
            configureView()
        }
    }
    
    @IBOutlet weak var editFolderButton: UIButton! {
        didSet {
            configureEditFolderButton()
        }
    }
    
    var headerConfiguration: HeaderCellConfiguration!
    
    var configuration: UIContentConfiguration  {
        get {
            return headerConfiguration
        }
        set {
            guard let newConfi = newValue as? HeaderCellConfiguration else { return }
            headerConfiguration = newConfi
        }
    }
    
    init(configuration: HeaderCellConfiguration) {
        super.init(frame: .zero)
        self.configuration = configuration
        loadView()
        firstConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadView() {
        Bundle.main.loadNibNamed("\(HeaderCellView.self)", owner: self)
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
        editFolderButton.translatesAutoresizingMaskIntoConstraints = false
        editFolderButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 5 * UIScreen.main.bounds.size.width / 390).isActive = true
        editFolderButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5 * UIScreen.main.bounds.size.width / 390).isActive = true
        editFolderButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5 * UIScreen.main.bounds.size.width / 390).isActive = true
        editFolderButton.widthAnchor.constraint(equalToConstant: 50 * UIScreen.main.bounds.size.width / 390).isActive = true
        editFolderButton.heightAnchor.constraint(equalToConstant: 50 * UIScreen.main.bounds.size.width / 390).isActive = true
        
    }
    
    func configureView() {
        view.backgroundColor = .systemGray6
    }
    
    func configureEditFolderButton() {
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 30.0 * UIScreen.main.bounds.size.width / 390, weight: .regular, scale: .small)
        let systemImage = UIImage(systemName: "line.3.horizontal", withConfiguration: symbolConfiguration)
        editFolderButton.setTitle("", for: .normal)
        editFolderButton.setImage(systemImage, for: .normal)
        editFolderButton.tintColor = .systemGray2
        editFolderButton.menu = createMenu()
        editFolderButton.showsMenuAsPrimaryAction = true
    }
    
    func createMenu() -> UIMenu {
        var menus = [UIMenuElement]()
        menus.append(UIAction(title: "フォルダの名前変更", image: UIImage(systemName: "arrow.right"), handler: { [weak self] _ in
            guard let self = self else { return }
            
            var folderName: String?
            let realm = try! Realm()
            let results = realm.objects(FolderManagerEntityRealm.self)
            if let folderManager = results.first {
                for (_ , folderEntity) in folderManager.folderEntities.enumerated() {
                    if folderEntity.id == headerConfiguration.folderId! {
                        folderName = folderEntity.name
                    }
                }
                NotificationCenter.default.post(name: .notifyRenameFolder, object: nil, userInfo: ["folderId": headerConfiguration.folderId!, "folderName": folderName!])
            }
        }))
        
        menus.append(UIAction(title: "フォルダを削除",image: UIImage(systemName: "trash"), attributes: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            
            NotificationCenter.default.post(name: .notifyDeleteFolder, object: nil, userInfo: ["folderId": headerConfiguration.folderId!])
        }))
        return UIMenu(title: "", options: .singleSelection, children: menus)
    }
    
}

extension Notification.Name {
    static let notifyDeleteFolder = Notification.Name("notifyDeleteFolder")
    static let notifyRenameFolder = Notification.Name("notifyRenameFolder")
}
