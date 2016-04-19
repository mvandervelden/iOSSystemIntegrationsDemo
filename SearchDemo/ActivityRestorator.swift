//  Copyright (c) 2015 Koninklijke Philips N.V. All rights reserved.

import Foundation

protocol ActivityRestorator {
    func restoreFromWeb(activity: NSUserActivity) -> Bool

    func restoreFromActivity(activity: NSUserActivity) -> Bool

    func restoreFromSpotlight(activity: NSUserActivity) -> Bool
}