

import Foundation
import RealmSwift

class MemoBodyEntity: Object, Identifiable {
    @objc dynamic var id = UUID()
    @objc dynamic var memobody = ""
}


