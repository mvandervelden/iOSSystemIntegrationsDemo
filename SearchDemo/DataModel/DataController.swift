import UIKit
import CoreData

class DataController {
    static let sharedInstance = DataController()

    var delegate : DataControllerDelegate?
    
    var managedObjectContext: NSManagedObjectContext

    init() {
        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = NSBundle.mainBundle().URLForResource("SearchDemo", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOfURL: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        self.managedObjectContext.persistentStoreCoordinator = psc
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            guard let groupURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.philips.pins.SearchGroup") else {
                fatalError("Error getting group location to store data model")
            }
            /* The directory the application uses to store the Core Data store file.
            This code uses a file named "DataModel.sqlite" in the application's documents directory.
            */
            let storeURL = groupURL.URLByAppendingPathComponent("DataModel.sqlite")
            do {
                try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
            } catch {
                fatalError("Error migrating store: \(error)")
            }
            dispatch_async(dispatch_get_main_queue()) {
                let storage = Storage()
                storage.prepare()
                self.delegate?.didInitializeStorage()
            }
        }
    }


    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                NSLog("Unresolved error \(error)")
            }
        }
    }
}