

import Foundation
import RealmSwift

class MemoEntity: Object, Identifiable {
    @objc dynamic var id = UUID()
    @objc dynamic var text = ""
}


