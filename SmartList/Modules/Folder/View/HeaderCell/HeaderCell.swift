

import Foundation
import UIKit

class HeaderCell: UICollectionViewListCell {
    
    func headerCellConfiguration() -> HeaderCellConfiguration {
        HeaderCellConfiguration()
    }
    
}

struct HeaderCellConfiguration: UIContentConfiguration {
    
    var folderId: FolderEntity.ID?
    var deleteBlock: ((MemoEntity.ID) -> Void)?
    var renameBlock: ((MemoEntity.ID) -> Void)?
    
    func updated(for state: UIConfigurationState) -> HeaderCellConfiguration {
        return self
    }
    
    func makeContentView() -> UIView & UIContentView {
        return HeaderCellView(configuration: self)
    }
    
}
