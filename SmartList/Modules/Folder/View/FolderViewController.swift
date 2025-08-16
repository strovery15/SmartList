

import UIKit

protocol FolderView: AnyObject {
    
}

class FolderViewController: UIViewController {
    var presenter: FolderPresentation!
    var folderEntity: FolderEntity!
    
    @IBOutlet weak var tableView: UITableView!
    
    init?(coder: NSCoder, folderEntity: FolderEntity) {
        super.init(coder: coder)
        self.folderEntity = folderEntity
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter.didAppear(self)
    }

}

extension FolderViewController: FolderView {
    
}

extension FolderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        folderEntity.memoTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = folderEntity.memoTitles[indexPath.row].title
        return cell
    }
    
}
