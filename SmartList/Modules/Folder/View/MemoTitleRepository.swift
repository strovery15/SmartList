

import Foundation
import RealmSwift

struct MemoTitlesRepository {
    
    var memoTitles: [MemoTitleEntity]
    var memoTitleIDs: [MemoTitleEntity.ID] { memoTitles.map(\.id) }
    
    func getMemoTitle(_ id: MemoTitleEntity.ID) -> MemoTitleEntity? {
        memoTitles.first(where: {$0.id == id})
    }
    
    init(_ memoTitles: [MemoTitleEntity]) {
        self.memoTitles = memoTitles
    }
}
