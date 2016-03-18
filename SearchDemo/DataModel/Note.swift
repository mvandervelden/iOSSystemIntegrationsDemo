import UIKit
import CoreData
import CoreSpotlight
import MobileCoreServices

class Note: NSManagedObject {
}

extension Note: Indexable {
    func index() {
        let item = CSSearchableItem(uniqueIdentifier: id, domainIdentifier: "com.philips.pins.SearchDemo.note", attributeSet: attributes())
        item.expirationDate = NSDate().dateByAddingTimeInterval(60 * 10)
        CSSearchableIndex.defaultSearchableIndex().indexSearchableItems([item]) {
            (error) -> Void in
            if (error != nil) {
                print(error?.localizedDescription)
            }
        }
    }

    func attributes() -> CSSearchableItemAttributeSet {
        let attributes = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)
        attributes.title = text
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        if let date = timestamp {
            attributes.contentDescription = formatter.stringFromDate(date)
        }
        attributes.keywords = ["note"]
        return attributes
    }
}
