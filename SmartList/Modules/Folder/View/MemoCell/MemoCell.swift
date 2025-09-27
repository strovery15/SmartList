

import Foundation
import UIKit

class MemoCell: UICollectionViewListCell {
    
    var id: MemoTitleEntity.ID?
    var title: String?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        
        var newConfiguration = MemoCellConfiguration().updated(for: state)
        newConfiguration.id = id
        newConfiguration.title = title
        
        if contentConfiguration == nil {
            contentConfiguration = newConfiguration
        } else {
            contentConfiguration = nil
            contentConfiguration = newConfiguration
        }
        
    }
}

struct MemoCellConfiguration: UIContentConfiguration {
    
    var id: MemoTitleEntity.ID?
    var title: String?
    
    func makeContentView() -> UIView & UIContentView {
        return MemoCellView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> MemoCellConfiguration {
        return self
    }
    
}
