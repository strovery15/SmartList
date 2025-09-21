

import UIKit
import RealmSwift

protocol MainView: AnyObject {
    func showFolderChief(_ folderChiefVc: UIViewController)
    func reShowFolderChief(_ folderChiefVc: UIViewController)
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

extension MainViewController: MainView {
    
    func showFolderChief(_ folderChiefVc: UIViewController) {
        addChild(folderChiefVc)
        view.addSubview(folderChiefVc.view)
        folderChiefVc.didMove(toParent: self)
    }
    
    func reShowFolderChief(_ folderChiefVc: UIViewController) {
        for childVc in children {
            childVc.willMove(toParent: nil)
            childVc.view.removeFromSuperview()
            childVc.removeFromParent()
        }
        addChild(folderChiefVc)
        view.addSubview(folderChiefVc.view)
        folderChiefVc.didMove(toParent: self)
    }
    
}

private extension MainViewController {
    
    func configureLayout() {
        let barButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(barButtonAction(_:)))
        self.navigationItem.rightBarButtonItem = barButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(notifyDeleteFolder(_:)), name: .notifyDeleteFolder, object: nil)
    }
    
    @objc func barButtonAction(_ sender: UIBarButtonItem) {
        let alert = addfolderAlert()
        present(alert, animated: true)
    }

    @objc func notifyDeleteFolder(_ notification: Notification) {
        let id = notification.userInfo!["id"] as! FolderEntity.ID
        presenter.deleteFolder(folderId: id)
    }
    
    func addfolderAlert() -> UIAlertController {
        let alert = UIAlertController(title: "フォルダの作成", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive) {[weak self] _ in
            guard let self = self else { return }
            if let textfields = alert.textFields {
                for textfield in textfields {
                    if textfield.text!.isEmpty {
                        presenter.addFolder(folderName: "新しいフォルダ")
                    } else {
                        presenter.addFolder(folderName: textfield.text!)
                    }
                }
            }
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
        alert.addTextField() { textfield in
            textfield.text = "新しいフォルダ"
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        return alert
    }
}
