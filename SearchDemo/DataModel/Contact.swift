
import Foundation
import CoreData
import CoreSpotlight
import MobileCoreServices

class Contact: NSManagedObject {
    
    class func create(name:String, phone:String, email:String) -> Contact {
        let contact = Contact.MR_createEntity()
        contact.name = name
        contact.phone = phone
        contact.email = email
        contact.index()
        return contact
    }}

extension Contact : Indexable {
    func index() {
        let item = CSSearchableItem(uniqueIdentifier: email, domainIdentifier: "com.philips.pins.SearchDemo.contact", attributeSet: attributes())
        item.expirationDate = NSDate().dateByAddingTimeInterval(60*10)
        CSSearchableIndex.defaultSearchableIndex().indexSearchableItems([item]) { (error) -> Void in
            if (error != nil) {
                print(error?.localizedDescription)
            }
        }
    }
    
    func  attributes() -> CSSearchableItemAttributeSet {
        let attributes = CSSearchableItemAttributeSet(itemContentType:kUTTypeContact as String)
        attributes.title = name
        if let email = email {
            attributes.emailAddresses = [email]
        }
        
        if let phone = phone {
            attributes.phoneNumbers = [phone]
        }
        attributes.keywords = ["contact"]
        return attributes
    }
}