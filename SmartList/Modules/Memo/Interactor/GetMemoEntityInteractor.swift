

import Foundation
import RealmSwift

protocol GetMemoEntityUseCase {
    func execute(_ parameter1: FolderEntity.ID,_ parameter2: MemoEntity.ID?, completion: ((Result<(memoId: MemoEntity.ID, text: String), Never>) -> ()))
}

class GetMemoEntityInteractor: GetMemoEntityUseCase {
    
    func execute(_ parameter1: FolderEntity.ID,_ parameter2: MemoEntity.ID?, completion: ((Result<(memoId: MemoEntity.ID, text: String), Never>) -> ())) {
        
        let realm = try! Realm()
        
        if parameter2 != nil {
            let results = realm.objects(MemoEntity.self)
            let predicate = NSPredicate(format: "id == %@", parameter2! as CVarArg)
            if let memoEntity = results.filter(predicate).first {
                completion(.success((parameter2!, memoEntity.text)))
            }
        } else {
            
        }
    }
    
    
}
