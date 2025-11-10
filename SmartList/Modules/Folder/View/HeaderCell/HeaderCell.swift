

import Foundation
import UIKit

class HeaderCell: UICollectionViewListCell {
    
    func headerCellConfiguration() -> HeaderCellConfiguration {
        HeaderCellConfiguration()
    }
    
}

struct HeaderCellConfiguration: UIContentConfiguration {
    
    var folderId: FolderEntityRealm.ID?
    
    func updated(for state: UIConfigurationState) -> HeaderCellConfiguration {
        return self
    }
    
    func makeContentView() -> UIView & UIContentView {
        return HeaderCellView(configuration: self)
    }
    
}
