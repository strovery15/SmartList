

import Foundation

class MemoEntity: Identifiable {
    
    var id: UUID
    var memo: String
    
    init(id: UUID, memo: String) {
        self.id = id
        self.memo = memo
    }
}
