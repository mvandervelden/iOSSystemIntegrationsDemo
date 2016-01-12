
import UIKit

struct NoteCellViewData {
    let title: String
}

struct ImageCellViewData {
    let image: UIImage
}

enum TableViewItem {
    case Note(viewData: NoteCellViewData)
    case Image(viewData: ImageCellViewData)
}

protocol Updatable: class {
    typealias ViewData
    
    func updateWithViewData(viewData: ViewData)
}