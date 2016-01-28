import Foundation
import CoreData

extension Note {
    @NSManaged var text: String?
    @NSManaged var id: String?
    @NSManaged var timestamp: NSDate?
}
