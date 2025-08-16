

import UIKit
import RealmSwift


protocol GetFolderViewConsUseCase {
    func execute(_ parameter: Void, completion: ((Result<[UIViewController], Never>) -> ())?)
}

class GetFolderViewCons: GetFolderViewConsUseCase {
    
    let appDependencies = AppDependencies.shared
    
    func execute(_ parameter: Void, completion: ((Result<[UIViewController], Never>) -> ())?) {
        var folderViewCons: [UIViewController]
        var folderEntities: [FolderEntity]
       
        folderEntities = getFolderEntities()
        folderViewCons = appDependencies.assembleFolderModules(folderEntities)
        
        completion?(.success(folderViewCons))
    }
    
    private func getFolderEntities() -> [FolderEntity] {
        
    }
    
}
