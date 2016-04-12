import UIKit
import CoreData
import CoreSpotlight
import MobileCoreServices

protocol Downloadable {
    func downloadImage(completion: (image:Image) -> Void)
}

class Image: NSManagedObject {
    var image: UIImage?
}

extension Image: Downloadable {
    func downloadImage(completion: (image:Image) -> Void) {
        if (image != nil) {
            completion(image: self)
            return
            
        }
        getData() {
            (data, response, error) in
            dispatch_async(dispatch_get_main_queue()) {
                () -> Void in
                guard let data = data where error == nil else {
                    return
                }
                self.image = UIImage(data: data)
                completion(image: self)
            }
        }
    }

    func getData(completion: ((data:NSData?, response:NSURLResponse?, error:NSError?) -> Void)) {
        if let urlString = url, let webUrl = NSURL(string: urlString) {
            NSURLSession.sharedSession().dataTaskWithURL(webUrl) {
                (data, response, error) in
                completion(data: data, response: response, error: error)
            }.resume()
        }
    }
}

extension Image: Indexable {
    func index() {
        downloadImage() {
            image in
            let item = CSSearchableItem(uniqueIdentifier: image.url, domainIdentifier: "com.philips.pins.SearchDemo.image", attributeSet: self.attributes())
            item.expirationDate = NSDate().dateByAddingTimeInterval(60 * 10)
            CSSearchableIndex.defaultSearchableIndex().indexSearchableItems([item]) {
                (error) -> Void in
                if (error != nil) {
                    print(error?.localizedDescription)
                }
            }
        }
    }

    func attributes() -> CSSearchableItemAttributeSet {
        let attributes = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)
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
        if let urlString = url, let webUrl = NSURL(string: urlString) {
            attributes.thumbnailURL = webUrl
        }

        if let uiImage = image {
            attributes.thumbnailData = UIImagePNGRepresentation(uiImage)
        }
        return attributes
    }
}