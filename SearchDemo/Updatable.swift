//  Copyright (c) 2015 Koninklijke Philips N.V. All rights reserved.

import Foundation

public protocol Updatable: class {
    associatedtype ViewData

    func updateWithViewData(viewData: ViewData)
}