

import Foundation
import RealmSwift

class MemoEntity: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var memobody = ""
}

class MemoTitleEntity: Object {
    //MemoEntity.idと共通id
    @objc dynamic var id = ""
    @objc dynamic var title = ""
}
