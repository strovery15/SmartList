

import Foundation
import RealmSwift

class RealmMemoIdEntity: Object {
    
    @objc dynamic var folderId = UUID()
    @objc dynamic var memoId = UUID()
}
