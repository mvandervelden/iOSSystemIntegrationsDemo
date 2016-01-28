    
import Foundation
import MagicalRecord

class Storage {
    class func allItems() -> [Indexable] {
        let noteList : [Indexable] = notes()
        let imageList : [Indexable] = images()
        return noteList + imageList
    }
    
    class func createContacts() {
        Contact.create("John Doe", phone:"+31 6 12 34 56 78", email:"john.doe@johndoe.com")
    }
    
    class func createNotes() {
        Note.create(NSDate(), text: "Foo")
        Note.create(NSDate(), text: "Bar")
    }
    
    class func createImages() {
        Image.create(NSDate(), title: "Apple", url:"http://logok.org/wp-content/uploads/2014/04/Apple-Logo-rainbow.png")
        Image.create(NSDate(), title: "Google", url:"https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/512px-Google_%22G%22_Logo.svg.png")
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
    class func getNoteByText(text : String) -> Note {
        return Note.MR_findFirstByAttribute("text", withValue: text) as Note
    }
    
    class func getImageByURL(url : String) -> Image {
        return Image.MR_findFirstByAttribute("url", withValue: url) as Image
    }
    
    class func getContactByEmail(email : String) -> Contact {
        return Contact.MR_findFirstByAttribute("email", withValue: email) as Contact
    }
}