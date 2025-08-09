

import Foundation
import RealmSwift

class MemoBodyEntity: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var body = ""
}

class MemoTitleEntity: Object {
    //idはMemoBodyEntity.idと共通
    @objc dynamic var id = ""
    @objc dynamic var title = ""
}
