
import Foundation
import CoreData
import CoreSpotlight
import MobileCoreServices

class Note: NSManagedObject{
    
    class func create(timestamp:NSDate, text:String) -> Note {
        let note = Note.MR_createEntity()
        note.timestamp = timestamp
        note.text = text
        note.id = NSUUID().UUIDString
        note.index()
        return note
    }
}

extension Note : Indexable {
    func index() {
        let item = CSSearchableItem(uniqueIdentifier: id, domainIdentifier: "com.philips.pins.SearchDemo.note", attributeSet: attributes())
        item.expirationDate = NSDate().dateByAddingTimeInterval(60*10)
        CSSearchableIndex.defaultSearchableIndex().indexSearchableItems([item]) { (error) -> Void in
            if (error != nil) {
                print(error?.localizedDescription)
            }
        }
    }
    
    func  attributes() -> CSSearchableItemAttributeSet {
        let attributes = CSSearchableItemAttributeSet(itemContentType:kUTTypeItem as String)
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
