
import UIKit

class ImageTableViewCell: UITableViewCell {
    func updateWithViewData(viewData: ImageCellViewData) {
        imageView?.image = viewData.image
    }
}