import UIKit

extension UIViewController {
    class func loadViewController(withIdentifier identifier: String, fromStoryboard storyboardName: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: NSBundle.mainBundle())
        return storyboard.instantiateViewControllerWithIdentifier(identifier)
    }
}

extension UIViewController {
    func show() {
        UIApplication.sharedApplication().keyWindow!.rootViewController = self
        let _ = self.view
    }
}