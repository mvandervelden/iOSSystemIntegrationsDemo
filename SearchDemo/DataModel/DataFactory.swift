import Foundation
import CoreData

class DataFactory {
    var managedObjectContext : NSManagedObjectContext  {
        return DataController.sharedInstance.managedObjectContext
    }
    
    func createNote(timestamp: NSDate, text: String) -> Note {
        let note = NSEntityDescription.insertNewObjectForEntityForName("Note", inManagedObjectContext: managedObjectContext) as! Note
        note.timestamp = timestamp
        note.text = text
        note.id = NSUUID().UUIDString
        note.index()
        return note
    }
    
    func createImage(timestamp: NSDate, title: String, url: String) -> Image {
        let image = NSEntityDescription.insertNewObjectForEntityForName("Image", inManagedObjectContext: managedObjectContext) as! Image
        image.timestamp = timestamp
        image.title = title
        image.url = url
        image.index()
        return image
    }
    
    func createContact(name: String, phone: String, email: String) -> Contact {
        let contact = NSEntityDescription.insertNewObjectForEntityForName("Contact", inManagedObjectContext: managedObjectContext) as! Contact
        contact.name = name
        contact.phone = phone
        contact.email = email
        contact.index()
        return contact
    }
}
