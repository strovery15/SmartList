

import UIKit

final class AppDependencies {
    
    func assembleMainModule() -> UIViewController {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? MainViewController else {
            fatalError()
        }
        viewController.presenter = MainPresenter(view: viewController, dependency: .init(makeFolderChiefViewCon: MakeFolderChiefViewConInteractor(), getFolders: GetFoldersInteractor(), addFolder: AddFolderInteractor(), deleteFolder: DeleteFolderInteractor()))
        return viewController
    }
    
    func assembleFolderModules(_ folderEntities: [FolderEntity]) -> [UIViewController] {
        var viewCons: [UIViewController] = []
        let storyboard = UIStoryboard(name: "Folder", bundle: nil)
        
        for entity in folderEntities {
            let viewController = storyboard.instantiateInitialViewController() as? FolderViewController
            let router = FolderRouter(view: viewController!)
            let presenter = FolderPresenter(view: viewController!, dependency: .init(router: router, getMemoTitles: GetMemoTitlesInteractor(), deleteMemoTitle: DeleteMemoTitleInteractor(), reorderMemoTitle: ReorderMemoTitleInteractor()))
            viewController!.folderId = entity.id
            viewController!.presenter = presenter
            viewCons.append(viewController!)
        }
        return viewCons
    }
    
    func assembleMemoModule(_ folderId: FolderEntity.ID,_ memoTitleId: MemoTitleEntity.ID?) -> UIViewController {
        let storyboard = UIStoryboard(name: "Memo", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as? MemoViewController
        viewController!.folderId = folderId
        viewController!.memoId = memoTitleId
        viewController!.presenter = MemoPresenter(view: viewController!, dependency: .init(getMemoEntity: GetMemoEntityInteractor(), deleteMemoEntity: DeleteMemoEntityInteractor(), saveMemoEntity: SaveMemoEntityInteractor()))
        return viewController!
    }
}
