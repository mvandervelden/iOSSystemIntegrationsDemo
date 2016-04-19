import UIKit
import CoreSpotlight

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dataController : DataController!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject:AnyObject]?) -> Bool {
        dataController = DataController.sharedInstance
        return true
    }

    func applicationWillTerminate(application: UIApplication) {
        dataController.saveContext()
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
}
