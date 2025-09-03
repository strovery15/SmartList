

import UIKit

protocol FolderView: AnyObject {
    func setRepository(_ entities: [MemoTitleEntity])
}

class FolderViewController: UIViewController {
    
    var presenter: FolderPresentation!
    var folderId: FolderEntity.ID!
    var memoTitlesRepository: MemoTitlesRepository!
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
    
}

extension FolderViewController: FolderView {
    func setRepository(_ entities: [MemoTitleEntity]) {
        self.memoTitlesRepository = MemoTitlesRepository(entities)
        applySnapshot()
    }
}

private extension FolderViewController {
    func configureLayout() {
        view.backgroundColor = .systemGray6
        
        editMenuButton.backgroundColor = .blue
        editMenuButton.menu = createMenu()
        editMenuButton.showsMenuAsPrimaryAction = true
        
        let Gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressRecognizer))
        collectionView.addGestureRecognizer(Gesture)
        collectionView.allowsSelection = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(notifyDeleteMemo(_:)), name: .notifyDeleteMemo, object: nil)
    }
    
    func createMenu() -> UIMenu {
        var menus = [UIMenuElement]()
        menus.append(UIAction(title: "フォルダの名前変更", image: UIImage(systemName: "arrow.right"), handler: {_ in
            print("移動")
        }))
        menus.append(UIAction(title: "フォルダを削除",image: UIImage(systemName: "trash"), attributes: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            NotificationCenter.default.post(name: .notifyDeleteFolder, object: nil, userInfo: ["id": self.folderId!])
        }))
        return UIMenu(title: "", options: .singleSelection, children: menus)
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

extension FolderViewController {
    //CollectionViewのセットアップ
    func configureCollectionViewLayout() {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.separatorConfiguration.bottomSeparatorInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        configuration.leadingSwipeActionsConfigurationProvider = { indexPath -> UISwipeActionsConfiguration in
            let action = UIContextualAction(style: .destructive, title: "削除") {
                [weak self] _, _, completionHandler in
                guard let self = self else { return }
                let memoId = self.dataSource.itemIdentifier(for: indexPath)!
                self.deleteCell(memoId)
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
                let memoTitle = self?.memoTitlesRepository.getMemoTitle(memoId)
                return collectionView.dequeueConfiguredReusableCell(using: itemCellRegistration, for: indexpath, item: memoTitle)
            })
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MemoTitleEntity.ID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(memoTitlesRepository.memoTitleIDs, toSection: .main)
        
        dataSource.reorderingHandlers.canReorderItem = { _ in true }
        dataSource.reorderingHandlers.didReorder = { [weak self] transAction in
            guard let self = self else { return }
            reorderCell(transAction)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
        
    }
    
    //CollectionViewのCell操作
    func deleteCell(_ id: MemoTitleEntity.ID) {
        var snapshot = self.dataSource.snapshot()
        snapshot.deleteItems([id])
        self.dataSource.apply(snapshot, animatingDifferences: true)
        self.memoTitlesRepository.memoTitles.removeAll { $0.id == id}
        presenter.deleteMemo(folderId: folderId, memoId: id)
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
        let item = memoTitlesRepository.memoTitles.remove(at: sourceIndex)
        memoTitlesRepository.memoTitles.insert(item, at: destinationIndex)
        presenter.reorderMemo(folderId: folderId, from: sourceIndex, to: destinationIndex)
    }
}

extension Notification.Name {
    static let notifyDeleteFolder = Notification.Name("notifyDeleteFolder")
}
