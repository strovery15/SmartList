

import Foundation

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
