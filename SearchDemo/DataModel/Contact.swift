import Foundation
import CoreData
import CoreSpotlight
import MobileCoreServices

class Contact: NSManagedObject {
}

extension Contact: Indexable {
    func index() {
        let item = CSSearchableItem(uniqueIdentifier: email, domainIdentifier: "com.philips.pins.SearchDemo.contact", attributeSet: attributes())
        item.expirationDate = NSDate().dateByAddingTimeInterval(60 * 10)
        CSSearchableIndex.defaultSearchableIndex().indexSearchableItems([item]) {
            (error) -> Void in
            if (error != nil) {
                print(error?.localizedDescription)
            }
        }
    }

    func attributes() -> CSSearchableItemAttributeSet {
        let attributes = CSSearchableItemAttributeSet(itemContentType: kUTTypeContact as String)
        attributes.title = name
        if let email = email {
            attributes.emailAddresses = [email]
        }

        if let phone = phone {
            attributes.phoneNumbers = [phone, "(888) 555-5521"]
            attributes.supportsPhoneCall = 1
        }
        attributes.contentDescription = phone! + "\n" + email!
        attributes.keywords = ["contact"]
        return attributes
    }
}