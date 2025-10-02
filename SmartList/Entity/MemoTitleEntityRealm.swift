

import Foundation
import RealmSwift

class MemoTitleEntityRealm: Object, Identifiable {
    //MemoBodyEntity.idと共通id
    @objc dynamic var id = UUID()
    @objc dynamic var title = ""
}
