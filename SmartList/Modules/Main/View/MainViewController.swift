

import UIKit

protocol MainView: AnyObject {
    func showFolderChief(_ folderChiefVC: UIViewController)
}

class MainViewController: UIViewController {
    var presenter: MainPresentation!

    override func viewDidLoad() {
        super.viewDidLoad()
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
