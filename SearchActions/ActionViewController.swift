//
//  ActionViewController.swift
//  SearchActions
//
//  Created by xiaochen.chen@philips.com on 15/03/16.
//  Copyright © 2016 Philips. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageTitleTextField: UITextField!

    var imageURLToSearch: NSURL?

    lazy var storage : Storage = {
        return Storage()
    }()

    lazy var factory : DataFactory = {
        return DataFactory()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        DataController.sharedInstance.delegate = self
    
        // look for an image and place it into an image view.
        var imageFound = false
        for item: AnyObject in self.extensionContext!.inputItems {
            let inputItem = item as! NSExtensionItem
            for provider: AnyObject in inputItem.attachments! {
                let itemProvider = provider as! NSItemProvider
                if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeImage as String) {
                    // This is an image. We'll load it, then place it in our image view.
                    weak var weakImageView = self.imageView
                    itemProvider.loadItemForTypeIdentifier(kUTTypeImage as String, options: nil, completionHandler: { (image, error) in
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                            if let strongImageView = weakImageView {
                                self.imageURLToSearch = image as? NSURL
                                let uiimage = UIImage(data: NSData(contentsOfURL: self.imageURLToSearch!)!)!
                                strongImageView.image = uiimage
                            }
                        }
                    })
                    
                    imageFound = true
                    break
                }
            }
            
            if (imageFound) {
                // We only handle one image, so stop looking for more.
                break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        if DataController.sharedInstance.storageInitialized, let imageURL = imageURLToSearch {

            var imageTitle = "My image" //TODO: add index

            if (!imageTitleTextField.text!.isEmpty) {
                imageTitle = imageTitleTextField.text!
            }

            factory.createImage(NSDate(), title: imageTitle, url: imageURL.absoluteString)
            DataController.sharedInstance.saveContext()
        }

        self.extensionContext!.completeRequestReturningItems(self.extensionContext!.inputItems, completionHandler: nil)
    }

}

extension ActionViewController: DataControllerDelegate {
    func didInitializeStorage() {


    }
}
