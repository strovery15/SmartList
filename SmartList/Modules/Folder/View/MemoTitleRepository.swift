

import Foundation

class MemoTitlesRepository {
    
    var memoTitles: [MemoTitle]
    var memoTitleIDs: [MemoTitleEntity.ID] { memoTitles.map(\.id) }
    
    func getMemoTitle(_ id: MemoTitleEntity.ID) -> MemoTitle? {
        memoTitles.first(where: {$0.id == id})
    }
    
    init(_ memoTitles: [MemoTitle]) {
        self.memoTitles = memoTitles
    }
}
