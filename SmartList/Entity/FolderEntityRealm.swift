

import Foundation
import RealmSwift

class FolderEntityRealm: Object, Identifiable {
    
    @objc dynamic var id = UUID()
    @objc dynamic var name = ""
    var memoTitles = List<MemoTitleEntityRealm>()
}


