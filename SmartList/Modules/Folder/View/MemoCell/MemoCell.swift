

import Foundation
import UIKit

class MemoCell: UICollectionViewListCell {
    
    func memoCellConfiguration() -> MemoCellConfiguration {
        MemoCellConfiguration()
    }
    
}

struct MemoCellConfiguration: UIContentConfiguration {
    
    var folderId: FolderEntityRealm.ID?
    var memoId: MemoTitleEntityRealm.ID?
    var title: String?
    
    func updated(for state: UIConfigurationState) -> MemoCellConfiguration {
        return self
    }
    
    func makeContentView() -> UIView & UIContentView {
        return MemoCellView(configuration: self)
    }
    
}
