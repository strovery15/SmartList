

import TabPageViewController

protocol MakeFolderChiefVCUseCase {
    func execute(_ parameter: [UIViewController], completion: ((Result<TabPageViewController, Never>) -> ())?)
}

class MakeFolderChiefVCInteractor: MakeFolderChiefVCUseCase {
    
    func execute(_ parameter: [UIViewController], completion: ((Result<TabPageViewController, Never>) -> ())?) {
        let folderChiefVC = TabPageViewController()
        folderChiefVC.tabItems = makeTabItems(parameter)
        folderChiefVC.option.tabHeight = 50
        folderChiefVC.option.tabMargin = 20
        folderChiefVC.option.fontSize = 14
        folderChiefVC.option.currentBarHeight = 3
        folderChiefVC.option.currentColor = .white
        folderChiefVC.option.defaultColor = .systemGray4
        folderChiefVC.option.tabBackgroundColor = .systemTeal
        completion?(.success(folderChiefVC))
    }
    
    private func makeTabItems(_ folderViewCons: [UIViewController]) -> [(UIViewController, String)] {
        var tabItems: [(UIViewController, String)] = []
//        let numberView = UIViewController()
//        let fruitView = UIViewController()
//        let prefectureView = UIViewController()
//        let subjectView = UIViewController()
        
        tabItems = [(numberView, "Number"), (fruitView, "fruit"), (prefectureView, "都道府県"), (subjectView, "教科")]
        
        return tabItems
    }
    
}
