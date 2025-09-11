

import Foundation

protocol MemoPresentation: AnyObject {
    
}

class MemoPresenter {
    
    weak var view: MemoView?
    
    init(view: MemoView? = nil) {
        self.view = view
    }
}

extension MemoPresenter: MemoPresentation {
    
}
