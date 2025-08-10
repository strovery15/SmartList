

import UIKit

protocol AppDependencies {
    func assembleMainModule() -> UIViewController
    func assembleFolderModules(_ folderEntities: [FolderEntity]) -> [UIViewController]
}

struct AppDefaultDependencies: AppDependencies {
    func assembleMainModule() -> UIViewController {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? MainViewController else {
            fatalError()
        }
        viewController.presenter = MainPresenter(view: viewController, dependency: .init(makeFolderChiefVC: MakeFolderChiefVCInteractor()))
        return viewController
    }
    
    func assembleFolderModules(_ folderEntities: [FolderEntity]) -> [UIViewController] {
        var viewCons: [UIViewController] = []
        let presenter = FolderPresenter(dependency: .init())
        let storyboard = UIStoryboard(name: "Folder", bundle: nil)
        
        for entity in folderEntities {
            let viewController = storyboard.instantiateViewController(identifier: "Folder") { coder in
                return FolderViewController(coder: coder, presenter: presenter, folderEntity: entity)
            }
            viewController.presenter = presenter
            viewCons.append(viewController)
        }
        return viewCons
    }
}
