

import UIKit
import RealmSwift

protocol FolderView: AnyObject {
    
    func setRepository(_ memoTitles: [MemoTitleEntity])
    func reSetRepository(_ memoTitles: [MemoTitleEntity])
}

class FolderViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    var presenter: FolderPresentation!
    var folderId: FolderEntityRealm.ID!
    var repository: MemoTitlesRepository!
    var dataSource: UICollectionViewDiffableDataSource<Section, MemoTitleEntityRealm.ID>!
    
    //reordering用の変数
    fileprivate var sourceIndex = 0
    fileprivate var destinationIndex = 0
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            configureCollectionView()
            configureCollectionViewLayout()
            configureDataSource()
        }
    }
    
    @IBOutlet weak var addMemoButton: UIButton! {
        didSet {
            configureAddMemoButton()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstConfiguration()
        presenter.didLoad(id: folderId)
    }
    
    
    @IBAction func addMemoButtonAction(_ sender: Any) {
        presenter.addMemo(folderId: folderId)
    }
    
}

// MARK: - Interface Method
extension FolderViewController: FolderView {
    
    func setRepository(_ memoTitles: [MemoTitleEntity]) {
        repository = MemoTitlesRepository(memoTitles: memoTitles)
        setSnapshot()
    }
    
    func reSetRepository(_ memoTitles: [MemoTitleEntity]) {
        let oldMemoTitleIDs = repository.memoTitleIDs
        let newMemoTitleIDs = memoTitles.map { $0.id }
        let diffarences = newMemoTitleIDs.difference(from: oldMemoTitleIDs)
        for diffarence in diffarences {
            switch diffarence {
                
            case .remove(_, element: let memoId,_):
                deleteSnapshot(memoId)
            case .insert(_, element: let memoId,_):
                addSnapshot(memoId)
            
            }
        }
        repository = MemoTitlesRepository(memoTitles: memoTitles)
        reSetSnapshot()
    }
    
}

// MARK: - Private Method
private extension FolderViewController {
    
    func firstConfiguration() {
        view.backgroundColor = .systemGray6
        
        configureLayout()
        
        NotificationCenter.default.addObserver(self, selector: #selector(notifyDismissMemoView(_:)), name: .notifyDismissMemoView, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(notifyDeleteMemo(_:)), name: .notifyDeleteMemo, object: nil)
        
    }
    
    func configureLayout() {
        //collectionView
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 53 * UIScreen.main.bounds.size.width / 390).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        //addMemoButton
        addMemoButton.translatesAutoresizingMaskIntoConstraints = false
        addMemoButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40 * UIScreen.main.bounds.size.width / 390).isActive = true
        addMemoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -45 * UIScreen.main.bounds.size.width / 390).isActive = true
        addMemoButton.widthAnchor.constraint(equalToConstant: 70 * UIScreen.main.bounds.size.width / 390).isActive = true
        addMemoButton.heightAnchor.constraint(equalToConstant: 70 * UIScreen.main.bounds.size.width / 390).isActive = true
    }
    
    @objc func notifyDismissMemoView(_ notification: Notification) {
        presenter.reloadMemo(id: folderId)
        
    }
    
    @objc func notifyDeleteMemo(_ notification: Notification) {
        
        let folderId = notification.userInfo!["folderId"] as! FolderEntityRealm.ID
        let memoId = notification.userInfo!["memoId"] as! MemoTitleEntityRealm.ID
        if folderId == self.folderId {
            let alertController = UIAlertController(title: "メモの削除", message: "このメモを削除しますか？", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "削除", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                repository.memoTitles.removeAll(where: {$0.id == memoId})
                deleteSnapshot(memoId)
                presenter.deleteMemo(folderId: folderId, memoId: memoId)
            }
            alertController.addAction(deleteAction)
            
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true)
        }
    }
    
}

// MARK: - UIComponent Method
extension FolderViewController {
    
    // CollectionView
    func configureCollectionView() {
        collectionView.allowsSelection = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapRecognizer))
        collectionView.addGestureRecognizer(tapGesture)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressRecognizer))
        collectionView.addGestureRecognizer(longPressGesture)
        
    }
    
    func configureCollectionViewLayout() {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.separatorConfiguration.bottomSeparatorInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        configuration.headerMode = .supplementary
        configuration.leadingSwipeActionsConfigurationProvider = { [weak self] indexPath -> UISwipeActionsConfiguration in
            let action = UIContextualAction(style: .destructive, title: "削除") {
                [weak self] _, _, completionHandler in
                guard let self = self else { return }
                let memoId = self.dataSource.itemIdentifier(for: indexPath)!
                repository.memoTitles.removeAll(where: {$0.id == memoId})
                deleteSnapshot(memoId)
                presenter.deleteMemo(folderId: folderId, memoId: memoId)
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
        let headerCellRegistration = UICollectionView.SupplementaryRegistration<HeaderCell>(elementKind: UICollectionView.elementKindSectionHeader) { [weak self] cell, _, _ in
            guard let self = self else { return }
            var configuration = cell.headerCellConfiguration()
            configuration.folderId = folderId
            cell.contentConfiguration = configuration
        }
        let memoCellRegistration = UICollectionView.CellRegistration<MemoCell, MemoTitleEntity> { [weak self] cell, indexpath, memoTitle in
            guard let self = self else { return }
            cell.automaticallyUpdatesContentConfiguration = false
            var configuration = cell.memoCellConfiguration()
            configuration.folderId = self.folderId
            configuration.memoId = memoTitle.id
            configuration.title = memoTitle.title
            cell.contentConfiguration = configuration
        }
        self.dataSource = UICollectionViewDiffableDataSource(
            collectionView: self.collectionView,
            cellProvider: { [weak self] collectionView, indexpath, memoId in
                guard let self = self else { return nil }
                let memoTitle = repository.getMemoTitle(memoId)
            return collectionView.dequeueConfiguredReusableCell(using: memoCellRegistration, for: indexpath, item: memoTitle)
            })
        
        dataSource.supplementaryViewProvider = { collectionView, elementKind, IndexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerCellRegistration, for: IndexPath)
        }
    }
    
    func setSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MemoTitleEntityRealm.ID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(repository.memoTitleIDs, toSection: .main)
        dataSource.reorderingHandlers.canReorderItem = { _ in true }
        dataSource.apply(snapshot, animatingDifferences: true)
        
    }
    
    func reSetSnapshot() {
        var snapshot = dataSource.snapshot()
        snapshot.reconfigureItems(repository.memoTitleIDs)
        dataSource.applySnapshotUsingReloadData(snapshot)
    }
    
    func addSnapshot(_ memoId: MemoTitleEntityRealm.ID) {
        if repository.memoTitleIDs.isEmpty {
            var snapshot = self.dataSource!.snapshot()
            snapshot.appendItems([memoId])
            dataSource.apply(snapshot, animatingDifferences: false)
        } else {
            var snapshot = self.dataSource!.snapshot()
            snapshot.insertItems([memoId], beforeItem: repository.memoTitleIDs[0])
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
    func deleteSnapshot(_ memoId: MemoTitleEntityRealm.ID) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([memoId])
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    @objc func tapRecognizer(gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            if let indexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) {
                let memoId = self.dataSource!.itemIdentifier(for: indexPath)!
                presenter.selectMemo(folderId: folderId, memoId: memoId)
            }
        }
    }
    
    @objc func longPressRecognizer(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            if let indexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) {
                sourceIndex = indexPath.row
                collectionView.beginInteractiveMovementForItem(at: indexPath)
            }
            
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
            if let indexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) {
                destinationIndex = indexPath.row
                let memoTitle = repository.memoTitles[sourceIndex]
                repository.memoTitles.remove(at: sourceIndex)
                repository.memoTitles.insert(memoTitle, at: destinationIndex)
                presenter.reorderMemo(folderId: folderId, from: sourceIndex, to: destinationIndex)
                sourceIndex = 0
                destinationIndex = 0
            }
            
        default:
            collectionView.cancelInteractiveMovement()
        }
        
    }
    
    //addMemoButton
    func configureAddMemoButton() {
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 30.0 * UIScreen.main.bounds.size.width / 390, weight: .regular, scale: .small)
        let systemImage = UIImage(systemName: "plus", withConfiguration: symbolConfiguration)
        addMemoButton.setTitle("", for: .normal)
        addMemoButton.setImage(systemImage, for: .normal)
        addMemoButton.backgroundColor = .systemTeal
        addMemoButton.tintColor = .white
        addMemoButton.layer.cornerRadius = 35  * UIScreen.main.bounds.size.width / 390
    }
    
}


