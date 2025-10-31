

import Foundation
import RealmSwift

class RealmMemoEntity: Object {
    
    @objc dynamic var id = UUID()
    @objc dynamic var memo = ""
}
