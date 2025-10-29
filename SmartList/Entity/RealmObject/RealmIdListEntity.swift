

import Foundation
import RealmSwift

class RealmIdListEntity: Object {
    
    var folderIds = List<RealmFolderIdEntity>()
    var memoIds = List<RealmMemoIdEntity>()
}
