

import UIKit
import RealmSwift

class HeaderCellView: UIView, UIContentView {
    
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var editFolderButton: UIButton!
    
    var folderId: FolderEntity.ID?
    var renameBlock: ((FolderEntity.ID) -> Void)?
    var deleteBlock: ((FolderEntity.ID) -> Void)?
    
    var headerConfiguration: HeaderCellConfiguration! {
        didSet {
            folderId = headerConfiguration.folderId!
            deleteBlock = headerConfiguration.deleteBlock
            renameBlock = headerConfiguration.renameBlock
        }
    }
    
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
        loadView()
        firstConfiguration()
        self.configuration = configuration
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
        
        editFolderButton.menu = createMenu()
        
        editFolderButton.translatesAutoresizingMaskIntoConstraints = false
        editFolderButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 5 * UIScreen.main.bounds.size.width / 390).isActive = true
        editFolderButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5 * UIScreen.main.bounds.size.width / 390).isActive = true
        editFolderButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5 * UIScreen.main.bounds.size.width / 390).isActive = true
        editFolderButton.widthAnchor.constraint(equalToConstant: 50 * UIScreen.main.bounds.size.width / 390).isActive = true
        editFolderButton.heightAnchor.constraint(equalToConstant: 50 * UIScreen.main.bounds.size.width / 390).isActive = true
    }
    
    func createMenu() -> UIMenu {
        var menuChildern = [UIMenuElement]()
        
        var renameAction = UIAction(title: "フォルダの名前変更", image: UIImage(systemName: "arrow.right"), handler: { [weak self] _ in
            guard let self = self else { return }
            renameBlock?(folderId!)
        })
        menuChildern.append(renameAction)
        
        var deleteAction = UIAction(title: "フォルダを削除",image: UIImage(systemName: "trash"), attributes: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            deleteBlock?(folderId!)
        })
        menuChildern.append(deleteAction)
        
        return UIMenu(title: "", options: .singleSelection, children: menuChildern)
    }
    
}
