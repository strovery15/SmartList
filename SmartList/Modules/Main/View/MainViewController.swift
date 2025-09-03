

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
        presenter.didLoad()
        configureLayout()
        print("--------------------------------")
    }
    
    func practiceFunc() {
        let number = ["1", "2", "3", "4", "5", "6", "7", "8"]
        let fruit = ["#Apple🍎", "#Banana🍌", "#Lemon🍋", "#Melon🍈", "#Grape🍇","#Strawbery🍓", "#PineApple🍍", "#Orange🍊", "#Cherry🍒", "#Peach🍑", "#Blueberry🫐", "#Watermelon🍉"]
        let prefecture = ["愛知県", "東京都", "福岡県", "兵庫県", "北海道", "山口県", "茨城県", "沖縄県", "石川県"]
        
        let realm = try! Realm()
        let folderEntity1 = createFolderEntiy(folderName: "Number", number)
        let folderEntity2 = createFolderEntiy(folderName: "fruit", fruit)
        let folderEntity3 = createFolderEntiy(folderName: "都道府県", prefecture)
        
        try! realm.write {
            realm.add(folderEntity1)
            realm.add(folderEntity2)
            realm.add(folderEntity3)
        }
    }
    
    func createFolderEntiy(folderName: String,_ items: [String]) -> FolderEntity {
        let folderEntity = FolderEntity()
        folderEntity.name = folderName
        for item in items {
            let memoTitleEntity = MemoTitleEntity()
            memoTitleEntity.title = item
            folderEntity.memoTitles.append(memoTitleEntity)
        }
        return folderEntity
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
        presenter.addFolder(folderName: "サード")
    }
    
    @objc func notifyDeleteFolder(_ notification: Notification) {
        let id = notification.userInfo!["id"] as! FolderEntity.ID
        presenter.deleteFolder(folderId: id)
    }
}
