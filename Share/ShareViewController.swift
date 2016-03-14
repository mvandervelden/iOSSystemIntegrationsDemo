//
//  ShareViewController.swift
//  Share
//
//  Created by maarten.van.der.velden@philips.com on 10/03/16.
//  Copyright © 2016 Philips. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {
    let maxCharacters = 200;
    
    override func presentationAnimationDidFinish() {
        super.presentationAnimationDidFinish()
        charactersRemaining = maxCharacters;
        placeholder = "Text you want to share"
    }

    override func configurationItems() -> [AnyObject]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        let item = SLComposeSheetConfigurationItem()
        item.title = "Change this"
        
        return [item]
    }

    override func loadPreviewView() -> UIView! {
        return super.loadPreviewView()
    }
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        let characterCount = textView.text.characters.count
        charactersRemaining = maxCharacters - characterCount
        if charactersRemaining.integerValue < 0 {
            return false
        }
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
    }
    
    override func didSelectCancel() {
        super.didSelectCancel()
    }
}
