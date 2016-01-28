import Foundation
import CoreData

extension Image {
    @NSManaged var url: String?
    @NSManaged var title: String?
    @NSManaged var timestamp: NSDate?
}
