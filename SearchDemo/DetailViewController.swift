import UIKit
import CoreSpotlight
import MobileCoreServices

class DetailViewController: UIViewController {
    
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var note: Note?
    var image: Image?
    var contact: Contact?
    var detailUserActivity: NSUserActivity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let note = note {
            
            noteLabel.text = note.text
            noteLabel.hidden = false
            
            detailUserActivity = note.activity()
            detailUserActivity.becomeCurrent()
        }
        
        if let image = image {
            
            imageView.image = image.image
            imageView.hidden = false
            
            detailUserActivity = image.activity()
            detailUserActivity.becomeCurrent()
        }
        
        if let contact = contact {
            noteLabel.text = contact.name! + "\n" + contact.phone!
            noteLabel.hidden = false

            detailUserActivity = contact.activity()
            detailUserActivity.becomeCurrent()
        }
        
    }
}

protocol Activity {
    func activity() -> NSUserActivity?
}

extension Note : Activity {
    func activity() -> NSUserActivity? {
        let userActivity = NSUserActivity(activityType: "com.philips.pins.SearchDemo")

        userActivity.webpageURL = NSURL(string: "https://tmp.ask-cs.nl/notes/" + text!.lowercaseString + "/")
        userActivity.userInfo = ["name": text!, "type": "note", "id":id!]
        userActivity.title = text
        userActivity.eligibleForHandoff = true;
        userActivity.eligibleForSearch = true;
        userActivity.requiredUserInfoKeys = NSSet(array: ["name", "type"]) as! Set<String>;
        
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)
        attributeSet.title = text
        attributeSet.contentDescription = "first test" + text!
        userActivity.contentAttributeSet = attributeSet
        return userActivity
    }
}

extension Image : Activity {
    func activity() -> NSUserActivity? {
        let activity = NSUserActivity(activityType: "com.philips.pins.SearchDemo")
        activity.userInfo = ["id": url!, "type": "image"]
        activity.title = title
        activity.eligibleForHandoff = true;
        activity.eligibleForSearch = true;
        return activity
    }
}

extension Contact : Activity {
    func activity() -> NSUserActivity? {
        let activity = NSUserActivity(activityType: "com.philips.pins.SearchDemo")
        activity.userInfo = ["id": email!, "type": "contact"]
        activity.title = name
        activity.eligibleForHandoff = true;
        activity.eligibleForSearch = true;
        return activity
    }
}