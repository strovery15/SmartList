

import UIKit

protocol FolderView: AnyObject {
    func setRepository(_ entities: [MemoTitleEntity])
}

class FolderViewController: UIViewController {
    
    var presenter: FolderPresentation!
    var folderId: FolderEntity.ID!
    var repository: MemoTitlesRepository!
    var dataSource: UICollectionViewDiffableDataSource<Section, MemoTitleEntity.ID>!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var editMenuButton: UIButton!
    
    enum Section {
        case main
    }
    
    init?(coder: NSCoder, folderId: FolderEntity.ID) {
        super.init(coder: coder)
        self.folderId = folderId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureCollectionViewLayout()
        configureDataSource()
        presenter.didLoad(view: self, folderId)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter.didAppear(view: self)
    }
    
    func configureLayout() {
        view.backgroundColor = .systemGray6
        
        editMenuButton.backgroundColor = .blue
        editMenuButton.menu = editMenu()
        editMenuButton.showsMenuAsPrimaryAction = true
        
        let Gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressRecognizer))
        collectionView.addGestureRecognizer(Gesture)
        collectionView.allowsSelection = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(notifyDeleteMemo(_:)), name: .notifyDeleteMemo, object: nil)
    }
    
}

extension FolderViewController: FolderView {
    func setRepository(_ entities: [MemoTitleEntity]) {
        self.repository = MemoTitlesRepository(entities)
        applySnapshot()
    }
}

extension FolderViewController {
    //CollectionViewのセットアップ
    func configureCollectionViewLayout() {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.separatorConfiguration.bottomSeparatorInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        configuration.leadingSwipeActionsConfigurationProvider = { indexPath -> UISwipeActionsConfiguration in
            let action = UIContextualAction(style: .destructive, title: "削除") {
                [weak self] _, _, completionHandler in
                guard let self = self else { return }
                let id = self.dataSource.itemIdentifier(for: indexPath)!
                var snapshot = self.dataSource.snapshot()
                snapshot.deleteItems([id])
                self.dataSource.apply(snapshot, animatingDifferences: true)
                self.repository.memoTitles.removeAll { $0.id == id}
                presenter.deleteMemo(folderId: folderId, memoId: id)
                completionHandler(true)
            }
            action.backgroundColor = UIColor.systemRed
            let swipeActionConfi = UISwipeActionsConfiguration(actions: [action])
            swipeActionConfi.performsFirstActionWithFullSwipe = false
            return swipeActionConfi
        }
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        collectionView.collectionViewLayout = layout
    }
    
    func configureDataSource() {
        let itemCellRegistration =
        UICollectionView.CellRegistration<MemoCell, MemoTitleEntity> {
            cell, indexpath, entity in
            
            cell.id = entity.id
            cell.title = entity.title
        }
        self.dataSource = UICollectionViewDiffableDataSource(
            collectionView: self.collectionView,
            cellProvider: { [weak self] collectionView, indexpath, memoId in
                let memoTitle = self?.repository.getMemoTitle(memoId)
                return collectionView.dequeueConfiguredReusableCell(using: itemCellRegistration, for: indexpath, item: memoTitle)
            })
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MemoTitleEntity.ID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(repository.memoTitleIDs, toSection: .main)
        
        dataSource.reorderingHandlers.canReorderItem = { _ in true }
        dataSource.reorderingHandlers.didReorder = { [weak self] transAction in
            guard let self = self else { return }
            reorderCell(transAction)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
        
    }
    
    //CollectionViewのCell操作
    func deleteCell(_ id: MemoTitleEntity.ID) {
        let alert = deleteMemoAlert(id)
        present(alert, animated: true)
    }
    
    func reorderCell(_ transAction:  NSDiffableDataSourceTransaction<FolderViewController.Section, MemoTitleEntity.ID>) {
        let oldArray = transAction.initialSnapshot.itemIdentifiers
        let newArray = transAction.finalSnapshot.itemIdentifiers
        let difference = newArray.difference(from: oldArray)
        
        var sourceIndex = 0
        var destinationIndex = 0
        for change in difference {
            switch change {
            case .insert(offset: let offset,_,_):
                destinationIndex = offset
            case .remove(offset: let offset,_,_):
                sourceIndex = offset
            }
        }
        let item = repository.memoTitles.remove(at: sourceIndex)
        repository.memoTitles.insert(item, at: destinationIndex)
        presenter.reorderMemo(folderId: folderId, from: sourceIndex, to: destinationIndex)
    }
}

private extension FolderViewController {
    
    func editMenu() -> UIMenu {
        var menus = [UIMenuElement]()
        menus.append(UIAction(title: "フォルダの名前変更", image: UIImage(systemName: "arrow.right"), handler: {_ in
            print("移動")
        }))
        menus.append(UIAction(title: "フォルダを削除",image: UIImage(systemName: "trash"), attributes: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            let alert = deleteFolderAlert()
            self.present(alert, animated: true)
        }))
        return UIMenu(title: "", options: .singleSelection, children: menus)
    }
    
    func deleteFolderAlert() -> UIAlertController {
        let alert = UIAlertController(title: "フォルダの削除", message: "このフォルダを削除しますか？", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "削除", style: .destructive) {[weak self] _ in
            guard let self = self else { return }
            NotificationCenter.default.post(name: .notifyDeleteFolder, object: nil, userInfo: ["id": self.folderId!])
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        return alert
    }
    
    func deleteMemoAlert(_ id: MemoTitleEntity.ID) -> UIAlertController {
        let alert = UIAlertController(title: "メモの削除", message: "このメモを削除しますか？", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "削除", style: .destructive) {[weak self] _ in
            guard let self = self else { return }
            var snapshot = self.dataSource.snapshot()
            snapshot.deleteItems([id])
            self.dataSource.apply(snapshot, animatingDifferences: true)
            self.repository.memoTitles.removeAll { $0.id == id}
            presenter.deleteMemo(folderId: folderId, memoId: id)
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        return alert
    }
    
    @objc func longPressRecognizer(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let targetIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {return}
            collectionView.beginInteractiveMovementForItem(at: targetIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    @objc func notifyDeleteMemo(_ notification: Notification) {
        let id = notification.userInfo!["id"] as! MemoTitleEntity.ID
        deleteCell(id)
    }
}

extension Notification.Name {
    static let notifyDeleteFolder = Notification.Name("notifyDeleteFolder")
}
