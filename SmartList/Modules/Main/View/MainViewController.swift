

import UIKit

protocol MainView: AnyObject {
    func showFolderChief(_ folderChiefVC: UIViewController)
}

class MainViewController: UIViewController {
    var presenter: MainPresentation!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "SmartList"
        presenter = MainPresenter(view: self, dependency: .init(makeFolderChiefVC: MakeFolderChiefVCInteractor()))
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
