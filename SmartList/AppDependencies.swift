

import UIKit

final class AppDependencies {
    
    private init() {}
    static let shared = AppDependencies()
    
    func assembleMainModule() -> UIViewController {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? MainViewController else {
            fatalError()
        }
        viewController.presenter = MainPresenter(view: viewController, dependency: .init(makeFolderChiefViewCon: MakeFolderChiefViewConInteractor(), getFolders: GetFoldersInteractor(), addFolder: AddFolderInteractor(), deleteFolder: DeleteFolderInteractor()))
        return viewController
    }
    
    func assembleFolderModules(_ folderEntities: [FolderEntity]) -> [UIViewController] {
        var viewCons: [UIViewController] = []
        let presenter = FolderPresenter(dependency: .init(router: FolderRouter(), getMemoTitles: GetMemoTitlesInteractor(), deleteMemoTitle: DeleteMemoTitleInteractor(), reorderMemoTitle: ReorderMemoTitleInteractor()))
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
    
    func assembleMemoModule(_ folderId: FolderEntity.ID,_ memoId: MemoTitleEntity.ID?) -> UIViewController {
        let storyboard = UIStoryboard(name: "Memo", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() { coder in
            return MemoViewController(coder: coder, folderId: folderId, memoId: memoId)
        }
        viewController!.presenter = MemoPresenter(view: viewController)
        return viewController!
    }
}
