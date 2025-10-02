

import Foundation
import UIKit

class HeaderCell: UICollectionViewListCell {
    
    func headerCellConfiguration() -> HeaderCellConfiguration {
        HeaderCellConfiguration()
    }
    
}

struct HeaderCellConfiguration: UIContentConfiguration {
    
    var folderId: FolderEntityRealm.ID?
    var title: String?
    
    func updated(for state: UIConfigurationState) -> HeaderCellConfiguration {
        return self
    }
    
    func makeContentView() -> UIView & UIContentView {
        return HeaderCellView(configuration: self)
    }
    
}
