

import Foundation

class MemoIdEntity: Identifiable {
    
    var folderId: UUID
    var memoId: UUID
    
    init(folderId: UUID, memoId: UUID) {
        self.folderId = folderId
        self.memoId = memoId
    }
}
