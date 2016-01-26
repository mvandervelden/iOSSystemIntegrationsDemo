
import Foundation
import CoreData
import CoreSpotlight

class Contact: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
}

extension Contact : Indexable {
    func index() {
        
    }
    
    func attributes() -> CSSearchableItemAttributeSet {
        return CSSearchableItemAttributeSet()
    }
}