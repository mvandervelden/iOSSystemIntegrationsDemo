
import UIKit

struct NoteCellViewData {
    let note: Note
}

struct ImageCellViewData {
    let image: Image
}

struct ContactCellViewData {
    let contact: Contact
}

enum TableViewItem {
    case Note(viewData: NoteCellViewData)
    case Image(viewData: ImageCellViewData)
    case Contact(viewData: ContactCellViewData)
}

protocol Updatable: class {
    typealias ViewData
    
    func updateWithViewData(viewData: ViewData)
}