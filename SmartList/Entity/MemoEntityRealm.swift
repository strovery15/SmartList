

import Foundation
import RealmSwift

class MemoEntityRealm: Object, Identifiable {
    
    @objc dynamic var id = UUID()
    @objc dynamic var text = ""
}


