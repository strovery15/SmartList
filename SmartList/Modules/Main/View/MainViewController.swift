

import UIKit
import RealmSwift
import TabPageViewController

protocol MainView: AnyObject {
    func setFolders(_ folderItems: [(UIViewController, String)],_ firstIndex: Int)
    func reSetFoldes(_ folderItems: [(UIViewController, String)],_ firstIndex: Int)
}

class MainViewController: UIViewController {
    
    var presenter: MainPresentation!
    
    var addFolderButton: UIButton!
    
    private var firstIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        practiceFunc()
        configureLayout()
        presenter.didLoad()
        print("--------------------------------")
    }
    
}

extension MainViewController: MainView {
    func setFolders(_ folderItems: [(UIViewController, String)], _ firstIndex: Int) {
        configureTabPageViewControllerAndButton(folderItems, firstIndex)
    }
    
    func reSetFoldes(_ folderItems: [(UIViewController, String)], _ firstIndex: Int) {
        for child in children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
        configureTabPageViewControllerAndButton(folderItems, firstIndex)
    }
    
}

private extension MainViewController {
    
    func configureLayout() {
        
        addFolderButton = UIButton()
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 30.0 * UIScreen.main.bounds.size.width / 390, weight: .regular, scale: .small)
        let systemImage = UIImage(systemName: "plus", withConfiguration: symbolConfiguration)
        addFolderButton.setImage(systemImage, for: .normal)
        addFolderButton.backgroundColor = .white
        addFolderButton.tintColor = .systemTeal
        
        addFolderButton.addTarget(self, action: #selector(addFolderButtonAction(_:)), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(notifyDeleteFolder(_:)), name: .notifyDeleteFolder, object: nil)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(<#T##@objc method#>), name: , object: nil)
    }
    
    @objc func addFolderButtonAction(_ sender: UIButton) {
        let alertController = UIAlertController(title: "フォルダの作成", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive) {[weak self] _ in
            guard let self = self else { return }
            if let textfields = alertController.textFields {
                for textfield in textfields {
                    if textfield.text!.isEmpty {
                        presenter.addFolder(folderName: "新しいフォルダ")
                    } else {
                        presenter.addFolder(folderName: textfield.text!)
                    }
                }
            }
        }
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
        alertController.addTextField() { textfield in
            textfield.text = "新しいフォルダ"
        }
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }

    @objc func notifyDeleteFolder(_ notification: Notification) {
        let id = notification.userInfo!["folderId"] as! FolderEntityRealm.ID
        let alertController = UIAlertController(title: "フォルダの削除", message: "このフォルダを削除しますか？", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "削除", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.presenter.deleteFolder(folderId: id)
        }
        alertController.addAction(deleteAction)

        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }
    
    @objc func notifyRenameFolder(_ notification: Notification) {
        let alertController = UIAlertController(title: "フォルダの作成", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive) {[weak self] _ in
            guard let self = self else { return }
            if let textfields = alertController.textFields {
                for textfield in textfields {
                    if textfield.text!.isEmpty {
                        presenter.addFolder(folderName: "新しいフォルダ")
                    } else {
                        presenter.addFolder(folderName: textfield.text!)
                    }
                }
            }
        }
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
        alertController.addTextField() { textfield in
            textfield.text = "新しいフォルダ"
        }
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
}

extension MainViewController {
    
    func configureTabPageViewControllerAndButton(_ folderItems: [(UIViewController, String)],_ firstIndex: Int) {
        let foldersVc = TabPageViewController()
        foldersVc.tabItems = folderItems
        foldersVc.firstIndex = firstIndex
        foldersVc.option.tabHeight = 53 * UIScreen.main.bounds.size.width / 390
        foldersVc.option.tabMargin = 20 * UIScreen.main.bounds.size.width / 390
        foldersVc.option.fontSize = 14 * UIScreen.main.bounds.size.width / 390
        foldersVc.option.currentBarHeight = 3
        foldersVc.option.currentColor = .systemTeal
        foldersVc.option.defaultColor = .systemGray
        foldersVc.option.tabBackgroundColor = .systemTeal
        
        addFolderButton.translatesAutoresizingMaskIntoConstraints = false
        foldersVc.view.addSubview(addFolderButton)
        
        addFolderButton.topAnchor.constraint(equalTo: foldersVc.view.safeAreaLayoutGuide.topAnchor).isActive = true
        addFolderButton.rightAnchor.constraint(equalTo: foldersVc.view.rightAnchor).isActive = true
        addFolderButton.widthAnchor.constraint(equalToConstant: 53 * UIScreen.main.bounds.size.width / 390).isActive = true
        addFolderButton.heightAnchor.constraint(equalToConstant: 53 * UIScreen.main.bounds.size.width / 390).isActive = true
        
        addChild(foldersVc)
        view.addSubview(foldersVc.view)
        foldersVc.didMove(toParent: self)
    }
}

//消す用
extension MainViewController {
    func practiceFunc() {
        let realm = try! Realm()
        let folderManagerEntity = FolderManagerEntityRealm()
        try! realm.write {
            realm.add(folderManagerEntity)
        }
        let number = ["1", "2", "3", "4", "5", "6", "7", "8"]
        let fruit = ["#Apple🍎", "#Banana🍌", "#Lemon🍋", "#Melon🍈", "#Grape🍇","#Strawbery🍓", "#PineApple🍍", "#Orange🍊", "#Cherry🍒", "#Peach🍑", "#Blueberry🫐", "#Watermelon🍉"]
        let prefecture = ["愛知県", "東京都", "福岡県", "兵庫県", "北海道", "山口県", "茨城県", "沖縄県", "石川県"]
        
        
        addFolderEntiy(folderName: "Number", number)
        addFolderEntiy(folderName: "fruit", fruit)
        addFolderEntiy(folderName: "都道府県", prefecture)
    }
    
    func addFolderEntiy(folderName: String,_ items: [String]) {
        let realm = try! Realm()
        let results = realm.objects(FolderManagerEntityRealm.self)
        if let folderManager = results.first {
            let folderEntity = FolderEntityRealm()
            folderEntity.name = folderName
            for item in items {
                let memoEntity = MemoEntityRealm()
                let memoTitleEntity = MemoTitleEntityRealm()
                memoEntity.text = item
                
                memoTitleEntity.id = memoEntity.id
                memoTitleEntity.title = memoEntity.text
                folderEntity.memoTitles.append(memoTitleEntity)
                try! realm.write {
                    realm.add(memoEntity)
                }
            }
            try! realm.write {
                folderManager.folderEntities.append(folderEntity)
            }
        }
    }
}
