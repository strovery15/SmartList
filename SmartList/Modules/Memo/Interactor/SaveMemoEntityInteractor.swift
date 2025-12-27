

import Foundation
import RealmSwift

protocol SaveMemoEntityUseCase {
    
    func execute(_ parameter1: MemoEntity.ID, _ parameter2: String)
}

class SaveMemoEntityInteractor: SaveMemoEntityUseCase {
    
    func execute(_ parameter1: MemoEntity.ID, _ parameter2: String) {
        let realm = try! Realm()
        let realmMemos = realm.objects(RealmMemoEntity.self)
        
        let realmMemo = realmMemos.first(where: { $0.id == parameter1 })!
        try! realm.write {
            realmMemo.memo = parameter2
        }
    }
    
}
