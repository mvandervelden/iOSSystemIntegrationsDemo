//
//  URLs.swift
//  SearchDemo
//
//  Created by xiaochen.chen@philips.com on 12/04/16.
//  Copyright © 2016 Philips. All rights reserved.
//

import Foundation

class URLs {

    var groupURL: NSURL {
        guard let url = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.philips.pins.SearchGroup") else {
            fatalError("Error getting group location to store data model")
        }

        return url
    }
    
}

