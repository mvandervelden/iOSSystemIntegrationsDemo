import UIKit
import CoreData

class Storage {
    lazy var factory : DataFactory = {
       return DataFactory()
    }()
    
    var managedObjectContext : NSManagedObjectContext {
        return DataController.sharedInstance.managedObjectContext
    }
    
    let contactsFetch = NSFetchRequest(entityName: "Contact")
    let notesFetch = NSFetchRequest(entityName: "Note")
    let imagesFetch = NSFetchRequest(entityName: "Image")
    
    func prepare() {
        if !hasNotes() {
            createNotes()
        }
        if !hasImages() {
            createImages()
        }
        if !hasContacts() {
            createContacts()
        }
    }

    func allItems() -> [Indexable] {
        let noteList: [Indexable] = notes()
        let imageList: [Indexable] = images()
        let contactList: [Indexable] = contacts()
        return noteList + imageList + contactList
    }

    func createContacts() {
        factory.createContact("John Doe", phone: "+31 6 12 34 56 78", email: "john.doe@johndoe.com")
    }

    func createNotes() {
        factory.createNote(NSDate(), text: "Foo")
        factory.createNote(NSDate(), text: "Bar")
    }

    func createImages() {
        factory.createImage(NSDate(), title: "Apple", url: "http://logok.org/wp-content/uploads/2014/04/Apple-Logo-rainbow.png")
        factory.createImage(NSDate(), title: "Google", url: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/512px-Google_%22G%22_Logo.svg.png")
    }

    func hasNotes() -> Bool {
        return notes().count > 0
    }

    func hasImages() -> Bool {
        return images().count > 0
    }

    func hasContacts() -> Bool {
        return contacts().count > 0
    }
    
    func notes() -> [Note] {
        do {
            return try managedObjectContext.executeFetchRequest(notesFetch) as! [Note]
        } catch {
            fatalError("Failed to fetch notes: \(error)")
        }
    }

    func images() -> [Image] {
        do {
            return try managedObjectContext.executeFetchRequest(imagesFetch) as! [Image]
        } catch {
            fatalError("Failed to fetch images: \(error)")
        }
    }

    func contacts() -> [Contact] {
        do {
            return try managedObjectContext.executeFetchRequest(contactsFetch) as! [Contact]
        } catch {
            fatalError("Failed to fetch contacts: \(error)")
        }
    }

    func getNoteByText(text: String) -> Note? {
        let noteRequest = NSFetchRequest(entityName: "Note")
        noteRequest.predicate = NSPredicate(format:"text == %@", text)
        do {
            let notesFound = try managedObjectContext.executeFetchRequest(noteRequest) as! [Note]
            return notesFound.first
        } catch {
            fatalError("Failed to fetch notes: \(error)")
        }
    }

    func getNoteById(id: String) -> Note? {
        let noteRequest = NSFetchRequest(entityName: "Note")
        noteRequest.predicate = NSPredicate(format:"id == %@", id)
        do {
            let notesFound = try managedObjectContext.executeFetchRequest(noteRequest) as! [Note]
            return notesFound.first
        } catch {
            fatalError("Failed to fetch notes: \(error)")
        }
    }

    func getImageByURL(url: String) -> Image? {
        let imageRequest = NSFetchRequest(entityName: "Image")
        imageRequest.predicate = NSPredicate(format:"url == %@", url)
        do {
            let imageFound = try managedObjectContext.executeFetchRequest(imageRequest) as! [Image]
            return imageFound.first
        } catch {
            fatalError("Failed to fetch images: \(error)")
        }
    }
    
    func getImageByTitle(title: String) -> Image? {
        let imageRequest = NSFetchRequest(entityName: "Image")
        imageRequest.predicate = NSPredicate(format:"title == %@", title)
        do {
            let imageFound = try managedObjectContext.executeFetchRequest(imageRequest) as! [Image]
            return imageFound.first
        } catch {
            fatalError("Failed to fetch images: \(error)")
        }
    }

    func getContactByEmail(email: String) -> Contact? {
        let contactRequest = NSFetchRequest(entityName: "Contact")
        contactRequest.predicate = NSPredicate(format:"email == %@", email)
        do {
            let contactFound = try managedObjectContext.executeFetchRequest(contactRequest) as! [Contact]
            return contactFound.first
        } catch {
            fatalError("Failed to fetch contacts: \(error)")
        }
    }
}