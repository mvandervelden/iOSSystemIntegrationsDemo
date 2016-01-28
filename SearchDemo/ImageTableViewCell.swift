
import UIKit

class ImageTableViewCell: UITableViewCell {
    func updateWithViewData(viewData: ImageCellViewData) {
        imageView?.image = viewData.image.image
    }
}

extension ImageTableViewCell: Updatable {
    typealias ViewData = ImageCellViewData
}