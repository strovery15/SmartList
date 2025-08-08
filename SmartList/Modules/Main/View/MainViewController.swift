

import UIKit

protocol MainView: AnyObject {
    func showListViews()
}

class MainViewController: UIViewController {
    var presenter: MainPresentation!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }


}

extension MainViewController: MainView {
    func showListViews() {
        
    }
    
}
