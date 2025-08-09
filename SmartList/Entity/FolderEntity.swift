

import Foundation
import RealmSwift

class FolderEntity: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    var memoTitles = List<MemoTitleEntity>()
}


