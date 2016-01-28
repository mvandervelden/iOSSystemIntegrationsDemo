import UIKit

class NoteTableViewCell: UITableViewCell {
    func updateWithViewData(viewData: NoteCellViewData) {
        textLabel?.text = viewData.note.text
    }
}

extension NoteTableViewCell: Updatable {
    typealias ViewData = NoteCellViewData
}