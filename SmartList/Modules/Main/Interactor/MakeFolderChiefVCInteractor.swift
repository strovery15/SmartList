

import TabPageViewController

protocol MakeFolderChiefVCUseCase {
    func execute(_ parameter: [FolderEntity], completion: ((Result<TabPageViewController, Never>) -> ())?)
}

class MakeFolderChiefVCInteractor: MakeFolderChiefVCUseCase {
    
    func execute(_ parameter: [FolderEntity], completion: ((Result<TabPageViewController, Never>) -> ())?) {
        let folderChiefVC = TabPageViewController()
        folderChiefVC.tabItems = makeTabItems(parameter)
        folderChiefVC.option.tabHeight = 50
        folderChiefVC.option.tabMargin = 20
        folderChiefVC.option.fontSize = 14
        folderChiefVC.option.currentBarHeight = 3
        folderChiefVC.option.currentColor = .white
        folderChiefVC.option.defaultColor = .systemGray4
        folderChiefVC.option.tabBackgroundColor = .systemTeal
        completion?(.success(folderChiefVC))
    }
    
    private func makeTabItems(_ folderEntities: [FolderEntity]) -> [(UIViewController, String)] {
        var tabItems: [(UIViewController, String)] = []
        let appDependencies = AppDependencies.shared
        
        let folderViewCons = appDependencies.assembleFolderModules(folderEntities) as! [FolderViewController]
        for folderEntity in folderEntities {
            let folderViewCon = folderViewCons.first(where: {
                $0.folderEntity.name == folderEntity.name
            })
            if let folderViewCon = folderViewCon {
                tabItems.append((folderViewCon, folderEntity.name))
            }
        }
        
        return tabItems
    }
}
