import UIKit
import CoreSpotlight
import CoreSpotlight
import MobileCoreServices

protocol Activity {
    func activity() -> NSUserActivity?
}

extension Note: Activity {
    func activity() -> NSUserActivity? {
        let userActivity = NSUserActivity(activityType: "com.philips.pins.SearchDemo")
        
        userActivity.webpageURL = NSURL(string: "https://tmp.ask-cs.nl/notes/" + text!.lowercaseString + "/")
        userActivity.userInfo = ["name": text!, "type": "note", "id": id!]
        userActivity.title = text
        userActivity.eligibleForHandoff = true;
        userActivity.eligibleForSearch = true;
        userActivity.requiredUserInfoKeys = NSSet(array: ["name", "type"]) as! Set<String>;
        
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)
        attributeSet.title = text
        attributeSet.contentDescription = "first search demo activity " + text!
        userActivity.contentAttributeSet = attributeSet
        
        return userActivity
    }
}

extension Image: Activity {
    func activity() -> NSUserActivity? {
        let activity = NSUserActivity(activityType: "com.philips.pins.SearchDemo")
        activity.webpageURL = NSURL(string: "https://tmp.ask-cs.nl/images/" + title!.lowercaseString + "/")
        activity.userInfo = ["id": url!, "type": "image", "title": title!.lowercaseString]
        activity.title = title
        activity.eligibleForHandoff = true
        activity.eligibleForSearch = true
        activity.requiredUserInfoKeys = NSSet(array: ["id", "type", "title"]) as! Set<String>;
        
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)
        attributeSet.title = title
        attributeSet.contentDescription = "first search demo activity " + title!
        attributeSet.thumbnailData = UIImagePNGRepresentation(image!)!
        
        activity.contentAttributeSet = attributeSet
        
        return activity
    }
}

extension Contact: Activity {
    func activity() -> NSUserActivity? {
        let activity = NSUserActivity(activityType: "com.philips.pins.SearchDemo")
        activity.userInfo = ["id": email!, "type": "contact"]
        activity.title = name
        activity.eligibleForHandoff = true;
        activity.eligibleForSearch = true;
        return activity
    }
}