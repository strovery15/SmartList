

import Foundation
import RealmSwift

struct MemoTitlesRepository {
    
    var memoTitles: [MemoTitleEntity]
    var memoTitleIDs: [MemoTitleEntityRealm.ID] { memoTitles.map(\.id) }
    
    func getMemoTitle(_ id: MemoTitleEntityRealm.ID) -> MemoTitleEntity? {
        memoTitles.first(where: {$0.id == id})
    }
}
