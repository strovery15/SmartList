

import UIKit
//import RealmSwift

protocol MainView: AnyObject {
    func showFolderChief(_ folderChiefVC: UIViewController)
}

class MainViewController: UIViewController {
    var presenter: MainPresentation!

    override func viewDidLoad() {
        super.viewDidLoad()
//        let realm = try! Realm()
//        var folderEntity1 = FolderEntity()
//        var folderEntity2 = FolderEntity()
//        folderEntity1.name = "ファースト"
//        folderEntity2.name = "セカンド"
//        try! realm.write {
//            realm.add(folderEntity1)
//            realm.add(folderEntity2)
//        }
        presenter.didLoad()
    }


}

extension MainViewController: MainView {
    func showFolderChief(_ folderChiefVC: UIViewController) {
        addChild(folderChiefVC)
        view.addSubview(folderChiefVC.view)
        folderChiefVC.didMove(toParent: self)
    }
    
}
