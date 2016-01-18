
import Foundation

class SpotlightHelper {
    class func indexAllRecords() {
        let items = Storage.allItems()
        for item in items {
            item.index()
        }
    }
}

@objc protocol Indexable: class {
    func index()
}
