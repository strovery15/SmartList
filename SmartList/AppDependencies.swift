

import UIKit

final class AppDependencies {
    
    private init() {}
    static let shared = AppDependencies()
    
    func assembleMainModule() -> UIViewController {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? MainViewController else {
            fatalError()
        }
        viewController.presenter = MainPresenter(view: viewController, dependency: .init(makeFolderChiefViewCon: MakeFolderChiefViewConInteractor(), getFolderEntities: GetFolderEntitiesInteractor(), addFolderEntity: AddFolderEntityInteractor()))
        return viewController
    }
    
    func assembleFolderModules(_ folderEntities: [FolderEntity]) -> [UIViewController] {
        var viewCons: [UIViewController] = []
        let presenter = FolderPresenter(dependency: .init(getMemoTitleEntities: GetMemoTitleEntitiesInteractor(), deleteMemoTitleEntity: DeleteMemoTitleEntityInteractor(), reorderMemoTitleEntity: ReorderMemoTitleEntityInteractor()))
        let storyboard = UIStoryboard(name: "Folder", bundle: nil)
        
        for entity in folderEntities {
            let viewController = storyboard.instantiateInitialViewController() { coder in
                return FolderViewController(coder: coder, folderId: entity.id)
            }
            viewController!.presenter = presenter
            viewCons.append(viewController!)
        }
        return viewCons
    }
}
