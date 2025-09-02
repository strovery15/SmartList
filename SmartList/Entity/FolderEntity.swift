

import Foundation
import RealmSwift

class FolderEntity: Object, Identifiable {
    @objc dynamic var id = UUID()
    @objc dynamic var name = ""
    var memoTitles = List<MemoTitleEntity>()
}


