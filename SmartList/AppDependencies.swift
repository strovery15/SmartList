

import UIKit

final class AppDependencies {
    
    private init() {}
    static let shared = AppDependencies()
    
    func assembleMainModule() -> UIViewController {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? MainViewController else {
            fatalError()
        }
        viewController.presenter = MainPresenter(view: viewController, dependency: .init(makeFolderChiefViewCon: UseCase(MakeFolderChiefViewConUseCase()), getFolderEntities: UseCase(GetFolderEntitiesUseCase()), addFolderEntity: UseCase(AddFolderEntityUseCase())))
        return viewController
    }
    
    func assembleFolderModules(_ folderEntities: [FolderEntity]) -> [UIViewController] {
        var viewCons: [UIViewController] = []
        let presenter = FolderPresenter(dependency: .init())
        let storyboard = UIStoryboard(name: "Folder", bundle: nil)
        
        for entity in folderEntities {
            guard let viewController = storyboard.instantiateInitialViewController() as? FolderViewController else {
                fatalError()
            }
            viewController.presenter = presenter
            viewController.folderEntity = entity
            viewCons.append(viewController)
        }
        return viewCons
    }
}
