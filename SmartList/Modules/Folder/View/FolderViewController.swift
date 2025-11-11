

import UIKit
import RealmSwift

protocol FolderView: AnyObject {
    
    func setRepository(_ memoTitles: [MemoTitleEntity])
}

class FolderViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    var presenter: FolderPresentation!
    var folderId: FolderEntity.ID!
    var repository: MemoTitlesRepository!
    var dataSource: UICollectionViewDiffableDataSource<Section, MemoTitleEntity.ID>!
    
    //reordering用の変数
    fileprivate var sourceId: MemoEntity.ID?
    fileprivate var destinationId: MemoEntity.ID?
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            configureCollectionViewLayout()
            configureDataSource()
        }
    }
    
    @IBOutlet weak var addMemoButton: UIButton!
    @IBOutlet weak var collectionViewTapGesture: UITapGestureRecognizer!
    @IBOutlet weak var collectionViewLongTapGesture: UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.didLoad(id: folderId)
    }
    
    @IBAction func addMemoButtonAction(_ sender: Any) {
        presenter.addMemo(folderId: folderId)
    }
    
    @IBAction func collectionViewTapAction(_ sender: Any) {
        if collectionViewTapGesture.state == .ended {
            if let indexPath = collectionView.indexPathForItem(at: collectionViewTapGesture.location(in: collectionView)) {
                let memoId = self.dataSource!.itemIdentifier(for: indexPath)!
                presenter.selectMemo(folderId: folderId, memoId: memoId)
            }
        }
    }
    
    @IBAction func collectionViewLongTapAction(_ sender: Any) {
        switch collectionViewLongTapGesture.state {
        case .began:
            if let indexPath = collectionView.indexPathForItem(at: collectionViewLongTapGesture.location(in: collectionView)) {
                sourceId = self.dataSource!.itemIdentifier(for: indexPath)!
                collectionView.beginInteractiveMovementForItem(at: indexPath)
            }
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(collectionViewLongTapGesture.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
            if let indexPath = collectionView.indexPathForItem(at: collectionViewLongTapGesture.location(in: collectionView)) {
                destinationId = self.dataSource!.itemIdentifier(for: indexPath)!
                presenter.reorderMemo(from: sourceId!, to: destinationId!)
                sourceId = nil
                destinationId = nil
            }
        default:
            collectionView.cancelInteractiveMovement()
            sourceId = nil
            destinationId = nil
        }
    }
    
}

// MARK: - Interface Method
extension FolderViewController: FolderView {
    
    func setRepository(_ memoTitles: [MemoTitleEntity]) {
        repository = MemoTitlesRepository(memoTitles)
        setSnapshot()
    }
}

// MARK: - Private Method
private extension FolderViewController {
    
    func firstConfiguration() {
        
        addMemoButton.backgroundColor = .systemTeal
        
        configureLayout()
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
    
}

// MARK: - UIComponent Method
extension FolderViewController {
    
    func configureCollectionViewLayout() {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.separatorConfiguration.bottomSeparatorInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        configuration.headerMode = .supplementary
        configuration.leadingSwipeActionsConfigurationProvider = { [weak self] indexPath -> UISwipeActionsConfiguration in
            let action = UIContextualAction(style: .destructive, title: "削除") {
                [weak self] _, _, completionHandler in
                guard let self = self else { return }
                let memoId = self.dataSource.itemIdentifier(for: indexPath)!
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
        let memoCellRegistration = UICollectionView.CellRegistration<MemoCell, MemoTitleEntity> { cell, indexpath, memoTitle in
            cell.automaticallyUpdatesContentConfiguration = false
            var configuration = cell.memoCellConfiguration()
            configuration.memoId = memoTitle.id
            configuration.title = memoTitle.title
            configuration.deleteBlock = { [weak self] memoId in
                self?.deleteSnapshot(memoId)
            }
            cell.contentConfiguration = configuration
        }
        
        let headerCellRegistration = UICollectionView.SupplementaryRegistration<HeaderCell>(elementKind: UICollectionView.elementKindSectionHeader) { [weak self] cell, _, _ in
            guard let self = self else { return }
            var configuration = cell.headerCellConfiguration()
            configuration.folderId = folderId
            configuration.deleteBlock = { folderId in
                print("delete-folder")
            }
            configuration.renameBlock = { folderId in
                print("rename-folder")
            }
            cell.contentConfiguration = configuration
        }
        
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: self.collectionView,
            cellProvider: { [weak self] collectionView, indexpath, memoId in
                guard let self = self else { return nil }
                let memoTitle = repository.getMemoTitle(memoId)
            return collectionView.dequeueConfiguredReusableCell(using: memoCellRegistration, for: indexpath, item: memoTitle)
            })
        
        dataSource.supplementaryViewProvider = { collectionView, elementKind, IndexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerCellRegistration, for: IndexPath)
        }
        dataSource.reorderingHandlers.canReorderItem = { _ in true }
    }
    
    func setSnapshot() {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        dataSource.apply(snapshot, animatingDifferences: true)
        var newSnapshot = NSDiffableDataSourceSnapshot<Section, MemoTitleEntity.ID>()
        newSnapshot.appendSections([.main])
        newSnapshot.appendItems(repository.memoTitleIDs, toSection: .main)
        dataSource.apply(newSnapshot, animatingDifferences: true)
    }
    
    func deleteSnapshot(_ memoId: MemoTitleEntity.ID) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([memoId])
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}


