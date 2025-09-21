

import UIKit
import RealmSwift
import TabPageViewController

protocol MainView: AnyObject {
    func setFolders(_ folderItems: [(UIViewController, String)])
    func reSetFoldes(_ folderItems: [(UIViewController, String)])
}

class MainViewController: UIViewController {
    
    var presenter: MainPresentation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        practiceFunc()
        configureLayout()
        presenter.didLoad()
        print("--------------------------------")
    }
    
}

extension MainViewController: MainView {
    
    func setFolders(_ folderItems: [(UIViewController, String)]) {
        configureTabPageViewController(folderItems)
    }
    
    func reSetFoldes(_ folderItems: [(UIViewController, String)]) {
        for child in children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
        configureTabPageViewController(folderItems)
    }
    
}

private extension MainViewController {
    
    func configureLayout() {
        let barButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(barButtonAction(_:)))
        self.navigationItem.rightBarButtonItem = barButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(notifyDeleteFolder(_:)), name: .notifyDeleteFolder, object: nil)
    }
    
    @objc func barButtonAction(_ sender: UIBarButtonItem) {
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
        let id = notification.userInfo!["id"] as! FolderEntity.ID
        presenter.deleteFolder(folderId: id)
    }
    
}

//消す用
extension MainViewController {
    
    func configureTabPageViewController(_ folderItems: [(UIViewController, String)]) {
        let foldersVc = TabPageViewController()
        foldersVc.tabItems = folderItems
        foldersVc.option.tabHeight = 50
        foldersVc.option.tabMargin = 20
        foldersVc.option.fontSize = 14
        foldersVc.option.currentBarHeight = 3
        foldersVc.option.currentColor = .white
        foldersVc.option.defaultColor = .systemGray4
        foldersVc.option.tabBackgroundColor = .systemTeal
        
        addChild(foldersVc)
        view.addSubview(foldersVc.view)
        foldersVc.didMove(toParent: self)
    }
}

extension MainViewController {
    func practiceFunc() {
        let number = ["1", "2", "3", "4", "5", "6", "7", "8"]
        let fruit = ["#Apple🍎", "#Banana🍌", "#Lemon🍋", "#Melon🍈", "#Grape🍇","#Strawbery🍓", "#PineApple🍍", "#Orange🍊", "#Cherry🍒", "#Peach🍑", "#Blueberry🫐", "#Watermelon🍉"]
        let prefecture = ["愛知県", "東京都", "福岡県", "兵庫県", "北海道", "山口県", "茨城県", "沖縄県", "石川県"]
        
        
        createFolderEntiy(folderName: "Number", number)
        createFolderEntiy(folderName: "fruit", fruit)
        createFolderEntiy(folderName: "都道府県", prefecture)
    }
    
    func createFolderEntiy(folderName: String,_ items: [String]) {
        let realm = try! Realm()
        let folderEntity = FolderEntity()
        folderEntity.name = folderName
        for item in items {
            let memoEntity = MemoEntity()
            let memoTitleEntity = MemoTitleEntity()
            memoEntity.text = item
            
            memoTitleEntity.id = memoEntity.id
            memoTitleEntity.title = memoEntity.text
            folderEntity.memoTitles.append(memoTitleEntity)
            try! realm.write {
                realm.add(memoEntity)
            }
        }
        try! realm.write {
            realm.add(folderEntity)
        }
    }
}
