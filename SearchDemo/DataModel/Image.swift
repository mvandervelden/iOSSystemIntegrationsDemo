
import Foundation
import UIKit
import CoreData
import CoreSpotlight
import MobileCoreServices

protocol Downloadable {
    func downloadImage(completion:(image:UIImage) -> Void)
}

class Image: NSManagedObject {
    var image : UIImage?
    // Insert code here to add functionality to your managed object subclass
    
}

extension Image : Downloadable {
    
    func downloadImage(completion: (image:UIImage) -> Void){
        if let image = image {
            completion(image:image)
        }
        getData() { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                self.image = UIImage(data: data)
                completion(image: self.image!)
            }
        }
    }
    
    func getData(completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        if let urlString = url, let webUrl = NSURL(string:urlString) {
            NSURLSession.sharedSession().dataTaskWithURL(webUrl) { (data, response, error) in
                completion(data: data, response: response, error: error)
                }.resume()
        }
    }
}

extension Image : Indexable {
    func index() {
        let attributes = CSSearchableItemAttributeSet(itemContentType:kUTTypeItem as String)
        attributes.title = title
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        if let date = timestamp {
            attributes.contentDescription = formatter.stringFromDate(date)
        }
        var keywords = ["image"]
        if let title = title {
            keywords.append(title)
        }
        attributes.keywords = keywords
        if let urlString = url, let webUrl = NSURL(string:urlString) {
            attributes.thumbnailURL = webUrl
        }
        downloadImage() {image in
            attributes.thumbnailData = UIImagePNGRepresentation(image)
        }
        let item = CSSearchableItem(uniqueIdentifier: url, domainIdentifier: "com.philips.pins.SearchDemo.image", attributeSet: attributes)
        item.expirationDate = NSDate().dateByAddingTimeInterval(60*10)
        CSSearchableIndex.defaultSearchableIndex().indexSearchableItems([item]) { (error) -> Void in
            if (error != nil) {
                print(error?.localizedDescription)
            }
        }
    }
}