import UIKit
import CoreData
import MagicalRecord
import CoreSpotlight

protocol ActivityRestorator {
    func restoreFromWeb(activity:NSUserActivity) -> Bool
    func restoreFromActivity(activity:NSUserActivity) -> Bool
    func restoreFromSpotlight(activity:NSUserActivity) -> Bool
}

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
        navigationController.popToRootViewControllerAnimated(false)

        guard let controller = viewControllerInStack(navigationController) else {
            return false
        }
        
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            return controller.restoreFromWeb(userActivity)
        }

        if userActivity.activityType == "com.philips.pins.SearchDemo" {
            return controller.restoreFromActivity(userActivity)
        }

        if userActivity.activityType == CSSearchableItemActionType {
            return controller.restoreFromSpotlight(userActivity)
        }
        return false
    }
    
    func viewControllerInStack(navigationController:UINavigationController) -> ViewController? {
        if let controller = navigationController.topViewController as? ViewController {
            return controller
        }
        return nil
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
