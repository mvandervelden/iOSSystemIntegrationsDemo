import UIKit

class ContactTableViewCell: UITableViewCell {
    func updateWithViewData(viewData: ContactCellViewData) {
        textLabel?.text = viewData.contact.name! + "       " + viewData.contact.phone!
    }
}

extension ContactTableViewCell: Updatable {
    typealias ViewData = ContactCellViewData
}