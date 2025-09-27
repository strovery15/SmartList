

import UIKit

protocol FolderView: AnyObject {
    
    func setRepository(_ memoTitles: [MemoTitle])
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
    fileprivate var sourceIndex = 0
    fileprivate var destinationIndex = 0
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            configureCollectionView()
            configureCollectionViewLayout()
            configureDataSource()
        }
    }
    
    @IBOutlet weak var editFolderButton: UIButton! {
        didSet {
            configureEditFolderButton()
            setEditMenu()
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
    
    func setRepository(_ memoTitles: [MemoTitle]) {
        repository = MemoTitlesRepository(memoTitles)
        setSnapshot()
    }
    
}

// MARK: - Private Method
private extension FolderViewController {
    
    func firstConfiguration() {
        view.backgroundColor = .systemGray6
        
        NotificationCenter.default.addObserver(self, selector: #selector(notifyDeleteMemo(_:)), name: .notifyDeleteMemo, object: nil)
    }
    
    @objc func notifyDeleteMemo(_ notification: Notification) {
        let memoId = notification.userInfo!["id"] as! MemoTitleEntity.ID
        let alertController = UIAlertController(title: "メモの削除", message: "このメモを削除しますか？", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "削除", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            deleteSnapshot(memoId)
            presenter.deleteMemo(folderId: folderId, memoId: memoId)
        }
        alertController.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
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
        let itemCellRegistration = UICollectionView.CellRegistration<MemoCell, MemoTitle> { cell, indexpath, memoTitle in
            
            cell.id = memoTitle.id
            cell.title = memoTitle.title
        }
        self.dataSource = UICollectionViewDiffableDataSource(
            collectionView: self.collectionView,
            cellProvider: { [weak self] collectionView, indexpath, memoId in
                guard let self = self else { return nil }
                let memoTitle = repository.getMemoTitle(memoId)
            return collectionView.dequeueConfiguredReusableCell(using: itemCellRegistration, for: indexpath, item: memoTitle)
            })
    }
    
    func setSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MemoTitleEntity.ID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(repository.memoTitleIDs, toSection: .main)
        dataSource.reorderingHandlers.canReorderItem = { _ in true }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    
    func deleteSnapshot(_ memoId: MemoTitleEntity.ID) {
        var snapshot = self.dataSource!.snapshot()
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
                presenter.reorderMemo(folderId: folderId, from: sourceIndex, to: destinationIndex)
                sourceIndex = 0
                destinationIndex = 0
            }
            
        default:
            collectionView.cancelInteractiveMovement()
        }
        
    }
    
    // editFolderButton
    func configureEditFolderButton() {
        editFolderButton.backgroundColor = .blue
        editFolderButton.showsMenuAsPrimaryAction = true
    }
    
    func setEditMenu() {
        var menus = [UIMenuElement]()
        menus.append(UIAction(title: "フォルダの名前変更", image: UIImage(systemName: "arrow.right"), handler: {_ in
            print("移動")
        }))
        
        menus.append(UIAction(title: "フォルダを削除",image: UIImage(systemName: "trash"), attributes: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            let alertController = UIAlertController(title: "フォルダの削除", message: "このフォルダを削除しますか？", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "削除", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                self.presenter.deleteFolder(folderId: self.folderId)
            }
            alertController.addAction(deleteAction)
            
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true)
        }))
        editFolderButton.menu = UIMenu(title: "", options: .singleSelection, children: menus)
    }
    
    //addMemoButton
    func configureAddMemoButton() {
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 30.0, weight: .regular, scale: .small)
        let systemImage = UIImage(systemName: "plus", withConfiguration: symbolConfiguration)
        addMemoButton.setTitle("", for: .normal)
        addMemoButton.setImage(systemImage, for: .normal)
        addMemoButton.backgroundColor = .systemTeal
        addMemoButton.tintColor = .white
        addMemoButton.frame = CGRect(x: 290, y: 730, width: 70, height: 70)
        addMemoButton.layer.cornerRadius = 35
    }
    
}


