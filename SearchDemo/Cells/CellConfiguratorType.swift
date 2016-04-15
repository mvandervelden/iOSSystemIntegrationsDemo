//  Copyright (c) 2015 Koninklijke Philips N.V. All rights reserved.

import UIKit

public protocol CellConfiguratorType {
    var reuseIdentifier: String { get }
    var cellClass: AnyClass { get }

    func updateCell(cell: UITableViewCell)
}