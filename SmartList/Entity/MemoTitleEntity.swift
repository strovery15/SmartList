

import Foundation
import RealmSwift

class MemoTitleEntity: Object, Identifiable {
    //MemoBodyEntity.idと共通id
    @objc dynamic var id = UUID()
    @objc dynamic var title = ""
}

class MemoTitlesRepository {
    
    var memoTitles: [MemoTitleEntity]
    var memoTitleIDs: [MemoTitleEntity.ID] { memoTitles.map(\.id) }
    
    func getMemoTitle(_ id: MemoTitleEntity.ID) -> MemoTitleEntity? {
        memoTitles.first(where: {$0.id == id})
    }
    
    init(_ entities: [MemoTitleEntity]) {
        self.memoTitles = entities
    }
}
