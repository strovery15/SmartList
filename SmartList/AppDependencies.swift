

import UIKit

protocol AppDependencies {
    func assembleMainModule() -> UIViewController
}

struct AppDefaultDependencies: AppDependencies {
    func assembleMainModule() -> UIViewController {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? MainViewController else {
            fatalError()
        }
        viewController.presenter = MainPresenter(view: viewController, dependency: .init(makeFolderChiefVC: MakeFolderChiefVCInteractor()))
        return viewController
    }
}
