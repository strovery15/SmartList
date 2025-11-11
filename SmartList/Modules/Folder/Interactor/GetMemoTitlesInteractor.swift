

import Foundation
import RealmSwift
import UIKit

protocol GetMemoTitlesUseCase {
    
    func execute(_ parameter: FolderEntity.ID, completion: ((Result<[MemoTitleEntity], Never>) -> ()))
}

class GetMemoTitlesInteractor: GetMemoTitlesUseCase {
    
    func execute(_ parameter: FolderEntity.ID, completion: ((Result<[MemoTitleEntity], Never>) -> ())) {
        let realm = try! Realm()
        let realmMemos = realm.objects(RealmMemoEntity.self)
        let realmIdManager = realm.objects(RealmIdManagerEntity.self).first!
        
        var realmMemosOrder: [RealmMemoEntity] = []
        for realmMemoId in realmIdManager.memoIds {
            if realmMemoId.folderId == parameter {
                let realmMemo = realmMemos.first(where: { $0.id == realmMemoId.memoId })!
                realmMemosOrder.append(realmMemo)
            }
        }
        
        var memos = objectMemos(realmMemosOrder)
        var memoTitlesAndIds = ommitMemos(memos)
        completion(.success(memoTitlesAndIds))
        
    }
    
    private func objectMemos(_ realmMemos: [RealmMemoEntity]) -> [MemoEntity] {
        var memos: [MemoEntity] = []
        for realmMemo in realmMemos {
            let memo = MemoEntity(id: realmMemo.id, memo: realmMemo.memo)
            memos.append(memo)
        }
        return memos
    }
    
    private func ommitMemos(_ memos: [MemoEntity]) -> [MemoTitleEntity] {
        var memoTitles: [MemoTitleEntity] = []
        let font = UIFont.systemFont(ofSize: 15)
        for memo in memos {
            var memoTitle = MemoTitleEntity(id: memo.id, title: memo.memo.quarry(with: font))
            memoTitles.append(memoTitle)
        }
        return memoTitles
    }
}

extension String {
    
    func quarry(with font: UIFont) -> String {
        var quarriedString = ""
        var singleStringArray: [String] = []
        let selfArray = Array(self).map{ String($0) }
        for element in selfArray {
            if element == "\n" {
                break
            } else if quarriedString.width(with: font) < UIScreen.main.bounds.width {
                singleStringArray.append(element)
                quarriedString = singleStringArray.joined()
            } else {
                break
            }
        }
        return quarriedString
    }
    
    private func width(with font: UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font : font]
        let singleStringWidth = (self as NSString).size(withAttributes: attributes).width
        return singleStringWidth
    }
}
