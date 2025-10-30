

import Foundation
import RealmSwift

class RealmIdManagerEntity: Object {
    
    var folderIds = List<RealmFolderIdEntity>()
    var memoIds = List<RealmMemoIdEntity>()
}
