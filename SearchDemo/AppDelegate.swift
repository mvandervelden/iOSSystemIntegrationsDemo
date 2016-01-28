import UIKit
import CoreData
import MagicalRecord
import CoreSpotlight

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject:AnyObject]?) -> Bool {
        MagicalRecord.setupCoreDataStack()
        if !Storage.hasNotes() {
            Storage.createNotes()
        }
        if !Storage.hasImages() {
            Storage.createImages()
        }
        if !Storage.hasContacts() {
            Storage.createContacts()
        }
        return true
    }

    func applicationWillTerminate(application: UIApplication) {
        self.saveContext()
    }

    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        let navigationController = self.window?.rootViewController as! UINavigationController

        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            if let paths = userActivity.webpageURL!.pathComponents {
                if paths.count > 1 {
                    if paths[1] == "notes" {
                        let topVC = navigationController.topViewController as! ViewController
                        if let text = Storage.getNoteByText(paths[2]) {
                            topVC.restoreItem(text)
                        }
                        return true
                    }
                }
            }
        }

        if userActivity.activityType == "com.philips.pins.SearchDemo" {
            navigationController.topViewController?.restoreUserActivityState(userActivity)
            return true
        }

        if userActivity.activityType == CSSearchableItemActionType {
            if let topVC = navigationController.topViewController as? ViewController {
                topVC.restoreCoreSpotlight(userActivity)
            }
            return true
        }

        return false
    }

    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count - 1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("SearchDemo", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }

        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    func saveContext() {
        if managedObjectContext.hasChanges {
            managedObjectContext.MR_saveToPersistentStoreAndWait()
        }
    }
}

