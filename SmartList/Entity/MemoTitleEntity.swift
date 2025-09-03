

import Foundation
import RealmSwift

class MemoTitleEntity: Object, Identifiable {
    //MemoBodyEntity.idと共通id
    @objc dynamic var id = UUID()
    @objc dynamic var title = ""
}
