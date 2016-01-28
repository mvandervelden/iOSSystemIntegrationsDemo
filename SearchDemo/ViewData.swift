
import UIKit

struct NoteCellViewData {
    let note: Note
}

struct ImageCellViewData {
    let image: Image
}

enum TableViewItem {
    case Note(viewData: NoteCellViewData)
    case Image(viewData: ImageCellViewData)
}

protocol Updatable: class {
    typealias ViewData
    
    func updateWithViewData(viewData: ViewData)
}