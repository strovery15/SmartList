

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
//        let realm = try! Realm()
//        var folderEntity1 = FolderEntity()
//        var folderEntity2 = FolderEntity()
//        folderEntity1.name = "ファースト"
//        folderEntity2.name = "セカンド"
//        try! realm.write {
//            realm.add(folderEntity1)
//            realm.add(folderEntity2)
//        }
        let barButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(barButtonAction(_:)))
        self.navigationItem.rightBarButtonItem = barButton
        presenter.didLoad()
    }
    
    @objc func barButtonAction(_ sender: UIBarButtonItem) {
        presenter.addFolder(folderName: "サード")
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
