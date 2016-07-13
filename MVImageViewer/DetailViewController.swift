// Created by mmvdv on 13/07/16.

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    
    var detailItem: AnyObject? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        if let label = detailDescriptionLabel {
            if let item = detailItem {
                label.text = item.description
            } else {
                label.text = ""
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
}

