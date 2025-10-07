

import Foundation
import RealmSwift
import UIKit

protocol SaveMemoEntityUseCase {
    func execute(_ parameter1: FolderEntityRealm.ID,_ parameter2: MemoEntityRealm.ID, _ parameter3: String)
}

class SaveMemoEntityInteractor: SaveMemoEntityUseCase {
    
    func execute(_ parameter1: FolderEntityRealm.ID, _ parameter2: MemoEntityRealm.ID, _ parameter3: String) {
        let realm = try! Realm()
        let folderManagerResults = realm.objects(FolderManagerEntityRealm.self)
        let memoResults = realm.objects(MemoEntityRealm.self)
        let memoPredicate = NSPredicate(format: "id == %@", parameter2 as CVarArg)
        if let folderManager = folderManagerResults.first {
            for (index, folderEntity) in folderManager.folderEntities.enumerated() {
                if folderEntity.id == parameter1 {
                    for (index, memoTitleEntity) in folderEntity.memoTitles.enumerated() {
                        if memoTitleEntity.id == parameter2 {
                            let font = UIFont.systemFont(ofSize: 15)
                            let screenWidth = UIScreen.main.bounds.width
                            let saveText = parameter3.quarryBy(with: font, by: screenWidth)
                            try! realm.write {
                                memoTitleEntity.title = saveText
                            }
                        }
                    }
                }
            }
        }
        if let memoEntity = memoResults.filter(memoPredicate).first {
            try! realm.write {
                memoEntity.text = parameter3
            }
        }
    }
    
}

extension String {
    func width(with font: UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font : font]
        return (self as NSString).size(withAttributes: attributes).width
    }
    
    func quarryBy(with font: UIFont, by width: CGFloat) -> String {
        var string = ""
        var array: [String] = []
        let selfArray = Array(self).map{String($0)}
        for element in selfArray {
            if element == "\n" {
                break
            } else if string.width(with: font) < width {
                array.append(element)
                string = array.joined()
            } else {
                break
            }
        }
        return string
    }
}

