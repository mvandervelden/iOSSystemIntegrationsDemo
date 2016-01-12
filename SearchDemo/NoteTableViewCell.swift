
import UIKit

class NoteTableViewCell: UITableViewCell {
    
    func updateWithViewData(viewData: NoteCellViewData) {
        textLabel?.text = viewData.title
    }
}