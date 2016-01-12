
import UIKit

let noteCellIdentifier = "NoteTableViewCell"
let imageCellIdentifier = "ImageTableViewCell"

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var items: [Any] = [
        NoteCellViewData(title: "Foo"),
        ImageCellViewData(image: UIImage(named: "apple")!),
        ImageCellViewData(image: UIImage(named: "google")!),
        NoteCellViewData(title: "Bar"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        registerCells()
    }
    
    func registerCells() {
        tableView.registerClass(NoteTableViewCell.self, forCellReuseIdentifier: noteCellIdentifier)
        tableView.registerClass(ImageTableViewCell.self, forCellReuseIdentifier: imageCellIdentifier)
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let viewData = items[indexPath.row]
        
        if (viewData is NoteCellViewData) {
            let cell = tableView.dequeueReusableCellWithIdentifier(noteCellIdentifier) as! NoteTableViewCell
            cell.updateWithViewData(viewData as! NoteCellViewData)
            return cell
        } else if (viewData is ImageCellViewData) {
            let cell = tableView.dequeueReusableCellWithIdentifier(imageCellIdentifier) as! ImageTableViewCell
            cell.updateWithViewData(viewData as! ImageCellViewData)
            return cell
        }
        
        fatalError()
    }
}