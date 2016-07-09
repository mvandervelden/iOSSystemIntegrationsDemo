import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageTitleLabel: UILabel!
    
    var note: Note?
    var image: Image?
    var contact: Contact?
    var detailUserActivity: NSUserActivity!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let note = note {
            noteLabel.text = note.text
            noteLabel.hidden = false

            detailUserActivity = note.activity()
            
            detailUserActivity.becomeCurrent()
        }

        if let image = image {
            imageView.image = image.image
            imageView.hidden = false

            imageTitleLabel.text = image.title!
            imageTitleLabel.hidden = false

            detailUserActivity = image.activity()
            detailUserActivity.becomeCurrent()
        }

        if let contact = contact {
            noteLabel.text = contact.name! + "\n" + contact.phone!
            noteLabel.hidden = false

            detailUserActivity = contact.activity()
            detailUserActivity.becomeCurrent()
        }
    }
}
