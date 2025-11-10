

import Foundation
import UIKit

class MemoCell: UICollectionViewListCell {
    
    func memoCellConfiguration() -> MemoCellConfiguration {
        MemoCellConfiguration()
    }
}

struct MemoCellConfiguration: UIContentConfiguration {
    
    var memoId: MemoTitleEntity.ID?
    var title: String?
    var deleteBlock: ((MemoEntity.ID) -> Void)?
    
    func updated(for state: UIConfigurationState) -> MemoCellConfiguration {
        return self
    }
    
    func makeContentView() -> UIView & UIContentView {
        return MemoCellView(configuration: self)
    }
    
}
