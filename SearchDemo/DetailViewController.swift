import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var note: String?
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if note != nil {
            noteLabel.text = note
            noteLabel.hidden = false
        }
        
        if image != nil {
            imageView.image = image
            imageView.hidden = false
        }
        
    }
}