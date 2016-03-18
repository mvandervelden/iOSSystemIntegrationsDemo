import Foundation
import CoreData

class DataFactory {
    lazy var dataController : DataController = {
        return DataController.sharedInstance
    }()
    
    func createNote(timestamp: NSDate, text: String) -> Note {
        let note = NSEntityDescription.insertNewObjectForEntityForName("Note", inManagedObjectContext: dataController.managedObjectContext) as! Note
        note.timestamp = timestamp
        note.text = text
        note.id = NSUUID().UUIDString
        note.index()
        return note
    }
    
    func createImage(timestamp: NSDate, title: String, url: String) -> Image {
        let image = NSEntityDescription.insertNewObjectForEntityForName("Image", inManagedObjectContext: dataController.managedObjectContext) as! Image
        image.timestamp = timestamp
        image.title = title
        image.url = url
        image.index()
        return image
    }
    
    func createContact(name: String, phone: String, email: String) -> Contact {
        let contact = NSEntityDescription.insertNewObjectForEntityForName("Contact", inManagedObjectContext: dataController.managedObjectContext) as! Contact
        contact.name = name
        contact.phone = phone
        contact.email = email
        contact.index()
        return contact
    }
}
