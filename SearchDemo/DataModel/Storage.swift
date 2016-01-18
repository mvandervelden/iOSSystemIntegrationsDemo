    
import Foundation
import MagicalRecord

class Storage {
    class func allItems() -> [Indexable] {
        let noteList : [Indexable] = notes()
        let imageList : [Indexable] = images()
        return noteList + imageList
    }
    
    class func createContacts() {
        let contact = Contact.MR_createEntity()
        contact.name = "John Doe"
        contact.phone = "+31 6 12 34 56 78"
        contact.email = "john.doe@johndoe.com"
    }
    
    class func createNotes() {
        let note = Note.MR_createEntity()
        note.text = "Foo"
        note.timestamp = NSDate()
        note.id = NSUUID().UUIDString
        let note2 = Note.MR_createEntity()
        note2.text = "Bar"
        note2.timestamp = NSDate()
        note2.id = NSUUID().UUIDString
    }
    
    class func createImages() {
        let image1 = Image.MR_createEntity()
        image1.timestamp = NSDate()
        image1.title = "apple"
        image1.url = "http://logok.org/wp-content/uploads/2014/04/Apple-Logo-rainbow.png"
        let image2 = Image.MR_createEntity()
        image2.timestamp = NSDate()
        image2.title = "google"
        image2.url = "https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/512px-Google_%22G%22_Logo.svg.png"
    }
    
    class func hasContacts() -> Bool {
        return Contact.MR_hasAtLeastOneEntity()
    }
    
    class func hasNotes() -> Bool {
        return Note.MR_hasAtLeastOneEntity()
    }
    
    class func hasImages() -> Bool {
        return Image.MR_hasAtLeastOneEntity()
    }
    
    class func notes() -> [Note] {
        return Note.MR_findAll() as! [Note]
    }
    
    class func images() -> [Image] {
        return Image.MR_findAll() as! [Image]
    }
}