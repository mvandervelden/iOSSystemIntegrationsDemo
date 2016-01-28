import UIKit
import CoreData
import MagicalRecord
import CoreSpotlight

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject:AnyObject]?) -> Bool {
        Storage.prepare()
        return true
    }

    func applicationWillTerminate(application: UIApplication) {
        self.saveContext()
    }

    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        let navigationController = self.window?.rootViewController as! UINavigationController

        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            return userActivity.restoreFromWeb(navigationController)
        }

        if userActivity.activityType == "com.philips.pins.SearchDemo" {
            return userActivity.restoreFromActivity(navigationController)
        }

        if userActivity.activityType == CSSearchableItemActionType {
            return userActivity.restoreFromSpotlight(navigationController)
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

extension NSUserActivity {
    func restoreFromWeb(navigationController:UINavigationController) -> Bool {
        guard let paths = webpageURL!.pathComponents
            where paths.count > 1
            else {
                return false
        }
        guard let topVC = navigationController.topViewController as? ViewController else {
            return false
        }
        
        navigationController.popToRootViewControllerAnimated(false)
        
        var itemToRestore: Indexable!
        if paths[1] == "notes" {
            itemToRestore = Storage.getNoteByText(paths[2])
        }
            
        else if paths[1] == ("images"){
            itemToRestore = Image.MR_findFirstByAttribute("title", withValue: paths[2].capitalizedString) as Image
        }
        
        topVC.restoreItem(itemToRestore)
        return true
        
        
        return false
    }
    
    func restoreFromActivity(navigationController:UINavigationController) -> Bool {
        navigationController.topViewController?.restoreUserActivityState(self)
        return true
    }
    
    func restoreFromSpotlight(navigationController:UINavigationController) -> Bool {
        if let topVC = navigationController.topViewController as? ViewController {
            topVC.restoreCoreSpotlight(self)
        }
        return true
    }
}

