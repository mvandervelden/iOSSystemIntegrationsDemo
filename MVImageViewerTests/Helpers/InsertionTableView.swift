//  Created by mmvdv on 14/07/16.

import UIKit

class InsertionTableView : UITableView {
    var insertedIndexPath : NSIndexPath?
    
    override func insertRowsAtIndexPaths(indexPaths: [NSIndexPath], withRowAnimation animation: UITableViewRowAnimation) {
        insertedIndexPath = indexPaths.first
    }
}