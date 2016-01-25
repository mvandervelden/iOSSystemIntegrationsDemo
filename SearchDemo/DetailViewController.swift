import UIKit
import CoreSpotlight
import MobileCoreServices

class DetailViewController: UIViewController {
    
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var note: String?
    var image: UIImage?
    var detailUserActivity: NSUserActivity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let note = note {
            
            noteLabel.text = note
            noteLabel.hidden = false
            
            detailUserActivity = NSUserActivity(activityType: "com.philips.pins.SearchDemo")
            detailUserActivity.webpageURL = NSURL(string: "https://tmp.ask-cs.nl/notes/" + note.lowercaseString + "/")
            detailUserActivity.userInfo = ["name": note, "type": "note"]
            detailUserActivity.title = note
            detailUserActivity.eligibleForHandoff = true;
            detailUserActivity.eligibleForSearch = true;
            detailUserActivity.requiredUserInfoKeys = NSSet(array: ["name", "type"]) as! Set<String>;
            
            let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)
            attributeSet.title = note
            attributeSet.contentDescription = "first test" + note
            detailUserActivity.contentAttributeSet = attributeSet
            
            detailUserActivity.becomeCurrent()
        }
        
        if let image = image {
            
            imageView.image = image
            imageView.hidden = false
            
            let activity = NSUserActivity(activityType: "com.philips.pins.SearchDemo")
            activity.userInfo = ["data": UIImagePNGRepresentation(image)!, "type": "image"]
            activity.title = ""
            activity.eligibleForHandoff = true;
            activity.eligibleForSearch = true;
            activity.becomeCurrent()
        }
        
    }
}