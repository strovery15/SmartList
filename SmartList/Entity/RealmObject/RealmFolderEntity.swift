

import Foundation
import RealmSwift

class RealmFolderEntity: Object {
    
    @objc dynamic var id = UUID()
    @objc dynamic var name = ""
}
