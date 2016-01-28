import Foundation
import CoreSpotlight

@objc protocol Indexable: class {
    func index()

    func attributes() -> CSSearchableItemAttributeSet
}
