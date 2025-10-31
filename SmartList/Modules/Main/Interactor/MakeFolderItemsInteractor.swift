

import UIKit
import RealmSwift

protocol MakeFolderItemsUseCase {
    
    func execute(_ parameter: [FolderEntity], completion: ((Result<[(UIViewController, String)], Never>) -> ()))
}

class MakeFolderItemsInteractor: MakeFolderItemsUseCase {
    
    func execute(_ parameter: [FolderEntity], completion: ((Result<[(UIViewController, String)], Never>) -> ())) {
        var tabItems: [(UIViewController, String)] = []
        let appDependencies = AppDependencies()
        
        let folderViewCons = appDependencies.assembleFolderModules(parameter) as! [FolderViewController]
        for folderEntity in parameter {
            let folderViewCon = folderViewCons.first(where: { $0.folderId == folderEntity.id })
            tabItems.append((folderViewCon, folderEntity.name))
        }
        completion(.success(tabItems))
    }
    
}
